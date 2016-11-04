//
//  ShekongBenController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ShekongBenController.h"
#import "CalendarHomeViewController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import "YLZGTitleLabel.h"
#import <MJExtension.h>
#import "PaizhaoPreViewController.h"
#import "XuanpianPreViewController.h"
#import "KanyangPreViewController.h"
#import "QujianPreViewController.h"


@interface ShekongBenController ()<UIScrollViewDelegate>

/** 日期 */
@property (copy,nonatomic) NSString *dateStr;
/** 当前索引 */
@property (assign,nonatomic) NSInteger currentIndex;
/** 是否刷新 */
@property (assign,nonatomic) BOOL isRefresh;


/** 顶部标签滚动栏 */
@property (strong, nonatomic) UIScrollView * titleScrollView;
/** 内容滚动栏 */
@property (strong, nonatomic) UIScrollView * contentScrollView;
/** 标签数组 */
@property (strong, nonatomic) NSArray * titleArray;

@end

@implementation ShekongBenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentIndex = 0;
    self.isRefresh = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString *ymd = [self getCurrentAreaDateAndTime];
    self.dateStr = [ymd substringWithRange:NSMakeRange(0, 10)];
    self.title = @"摄控本(今日预约)";
    
    self.titleArray = @[@"拍照预约",@"选片预约",@"看样预约",@"取件预约"];
    /** 初始化顶部标签滚动栏 */
    [self setupTitleScrollView];
    
    /** 初始化内容滚动栏 */
    [self setupContentScrollView];
    
    /** 添加子控制器 */
    [self addController];
    
    /** 添加标签 */
    [self addLabel];
    
    /** 添加默认控制器 */
    [self addDefaultController];
    
    
}


#pragma mark -推迟30天
- (NSString *)delayThirty {
    int addDays = 29;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * str = [self getCurrentTime];
    NSDate * myDate = [dateFormatter dateFromString:str];
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * addDays];
    
    NSString * returnStr = [dateFormatter stringFromDate:newDate];
    return returnStr;
}


/** 添加默认控制器 */
- (void)addDefaultController
{
    PaizhaoPreViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:vc.view];
    YLZGTitleLabel *lable = [self.titleScrollView.subviews firstObject];
    lable.scale = 1.0;
    // 第一次进来时调用
    [vc loadDataWithDate:self.dateStr];
}


/** 添加子控制器 */
- (void)addController
{
    PaizhaoPreViewController *vc1 = [[PaizhaoPreViewController alloc] init];
    [self addChildViewController:vc1];
    
    XuanpianPreViewController *vc2 = [XuanpianPreViewController new];
    [self addChildViewController:vc2];
    
    KanyangPreViewController *vc3 = [KanyangPreViewController new];
    [self addChildViewController:vc3];
    
    QujianPreViewController *vc4 = [QujianPreViewController new];
    [self addChildViewController:vc4];
}

/** 添加标签 */
- (void)addLabel
{
    CGFloat labelW = SCREEN_WIDTH/4;
    CGFloat labelH = 45;
    CGFloat labelY = 0;
    for (int i = 0; i < self.titleArray.count; i++) {
        CGFloat labelX = i * labelW;
        YLZGTitleLabel * label = [[YLZGTitleLabel alloc] init];
        label.text = self.titleArray[i];
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.font = [UIFont systemFontOfSize:15];
        label.tag = i;
        [self.titleScrollView addSubview:label];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderTitleClick:)]];
    }
    self.titleScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
}

/** 标签点击方法 */
- (void)orderTitleClick:(UITapGestureRecognizer *)recognizer
{
    YLZGTitleLabel *titlelable = (YLZGTitleLabel *)recognizer.view;
    
    CGFloat offsetX = titlelable.tag * self.contentScrollView.frame.size.width;
    
    CGFloat offsetY = self.contentScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.contentScrollView setContentOffset:offset animated:YES];
    
}



/** 初始化顶部标签滚动栏 */
- (void)setupTitleScrollView
{
    UIScrollView * titleScrollView = [[UIScrollView alloc] init];
    titleScrollView.backgroundColor = [UIColor whiteColor];
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.showsVerticalScrollIndicator = NO;
    titleScrollView.y = 0;
    titleScrollView.width = self.view.width;
    titleScrollView.height = 45;
    self.titleScrollView = titleScrollView;
    [self.view addSubview:self.titleScrollView];
}

/** 初始化内容滚动栏 */
- (void)setupContentScrollView
{
    
    UIScrollView * contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.delegate = self;
    contentScrollView.y = CGRectGetMaxY(self.titleScrollView.frame);
    contentScrollView.width = self.view.width;
    
    // 判断是否是点击tabbar中间加号进来的，如果是则不减去tabbar的高度
    CGFloat scrollViewH;
    scrollViewH = self.view.height - 64 - self.titleScrollView.height;
    contentScrollView.height = scrollViewH;
    
    contentScrollView.contentSize = CGSizeMake(self.view.width * self.titleArray.count, 0);
    contentScrollView.pagingEnabled = YES;
    self.contentScrollView = contentScrollView;
    [self.view insertSubview:self.contentScrollView belowSubview:self.titleScrollView];
}



#pragma mark - scrollView代理方法
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    // 如果索引和之前的一样，那就不刷新
    NSInteger tempIndex = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    if (tempIndex == self.currentIndex) {
        self.isRefresh = NO;
    }else{
        self.isRefresh = YES;
    }
    
    // 获得索引
    self.currentIndex = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    
    // 滚动标题栏
    YLZGTitleLabel *titleLable = (YLZGTitleLabel *)self.titleScrollView.subviews[self.currentIndex];
    
    CGFloat offsetx = titleLable.center.x - self.titleScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.titleScrollView.contentOffset.y);
    [self.titleScrollView setContentOffset:offset animated:YES];
    // 添加控制器
    if (self.currentIndex == 0) {
        // 拍照
        PaizhaoPreViewController *newsVc = self.childViewControllers[self.currentIndex];
        newsVc.index = self.currentIndex;
        
// #warning 小BUG：每次进来都需要刷新一遍
        
        if (self.isRefresh) {
            [newsVc loadDataWithDate:self.dateStr];
        }
        [self.titleScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx != self.currentIndex) {
                YLZGTitleLabel *temlabel = self.titleScrollView.subviews[idx];
                temlabel.scale = 0.0;
            }
        }];
        if (newsVc.view.superview) return;
        newsVc.view.frame = scrollView.bounds;
        [self.contentScrollView addSubview:newsVc.view];
    } else if(self.currentIndex == 1){
        // 选片
        XuanpianPreViewController *newsVc = self.childViewControllers[self.currentIndex];
        newsVc.index = self.currentIndex;
        if (self.isRefresh) {
            [newsVc loadDataWithDate:self.dateStr];
        }
        
        [self.titleScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx != self.currentIndex) {
                YLZGTitleLabel *temlabel = self.titleScrollView.subviews[idx];
                temlabel.scale = 0.0;
            }
        }];
        if (newsVc.view.superview) return;
        newsVc.view.frame = scrollView.bounds;
        [self.contentScrollView addSubview:newsVc.view];
    }else if (self.currentIndex == 2){
        // 看样
        KanyangPreViewController *newsVc = self.childViewControllers[self.currentIndex];
        newsVc.index = self.currentIndex;
        if (self.isRefresh) {
            [newsVc loadDataWithDate:self.dateStr];
        }
        
        [self.titleScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx != self.currentIndex) {
                YLZGTitleLabel *temlabel = self.titleScrollView.subviews[idx];
                temlabel.scale = 0.0;
            }
        }];
        if (newsVc.view.superview) return;
        newsVc.view.frame = scrollView.bounds;
        [self.contentScrollView addSubview:newsVc.view];
    }else{
        // 取件
        QujianPreViewController *newsVc = self.childViewControllers[self.currentIndex];
        newsVc.index = self.currentIndex;
        if (self.isRefresh) {
            [newsVc loadDataWithDate:self.dateStr];
        }
        
        [self.titleScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx != self.currentIndex) {
                YLZGTitleLabel *temlabel = self.titleScrollView.subviews[idx];
                temlabel.scale = 0.0;
            }
        }];
        if (newsVc.view.superview) return;
        newsVc.view.frame = scrollView.bounds;
        [self.contentScrollView addSubview:newsVc.view];
    }
    
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    YLZGTitleLabel *labelLeft = self.titleScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.titleScrollView.subviews.count) {
        YLZGTitleLabel *labelRight = self.titleScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"change_calender"] style:UIBarButtonItemStylePlain target:self action:@selector(changeDate)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
#pragma mark - 切换日期
- (void)changeDate
{
    
    ZCAccount * account = [ZCAccountTool account];
    NSString * url = [NSString stringWithFormat:ShekongRili_Url, account.userID, [self getCurrentTime], [self delayThirty],(int)self.currentIndex];
    KGLog(@"url = %@",url);
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        CalendarHomeViewController *calender = [[CalendarHomeViewController alloc]init];
        if (self.currentIndex == 0) {
            calender.calendartitle = @"查看拍照预约数";
        } else if(self.currentIndex == 1){
            calender.calendartitle = @"查看选片预约数";
        }else if (self.currentIndex == 2){
            calender.calendartitle = @"查看化妆预约数";
        }else{
            calender.calendartitle = @"查看取件预约数";
        }
        [calender.planArray removeAllObjects];
        calender.planArray = [[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"result"]];
        [calender setAirPlaneToDay:365 ToDateforString:nil];
        __weak ShekongBenController * weakSelf = self;
        calender.calendarblock = ^(CalendarDayModel *model){
            NSString *chooseDate = [NSString stringWithFormat:@"%@",[model toString]];
            if (model.holiday) {
                self.title = [NSString stringWithFormat:@"摄控本(%@)",model.holiday];
            }else{
                self.title = [NSString stringWithFormat:@"摄控本(%@)",chooseDate];
            }
            
            NSString *currentDate = weakSelf.dateStr;
            if ([currentDate isEqualToString:chooseDate]) {
                return ;
            }
            weakSelf.dateStr = chooseDate;
            
            // 通知控制器刷新数据
            if (self.currentIndex == 0) {
                // 拍照
                PaizhaoPreViewController *newsVc = self.childViewControllers[self.currentIndex];
                [newsVc loadDataWithDate:chooseDate];
            }else if (self.currentIndex == 1) {
                // 选片
                XuanpianPreViewController *newsVc = self.childViewControllers[self.currentIndex];
                [newsVc loadDataWithDate:chooseDate];
            }else if (self.currentIndex == 2) {
                // 看样
                KanyangPreViewController *newsVc = self.childViewControllers[self.currentIndex];
                [newsVc loadDataWithDate:chooseDate];
            }else{
                // 取件
                QujianPreViewController *newsVc = self.childViewControllers[self.currentIndex];
                [newsVc loadDataWithDate:chooseDate];
            }
            
        };
        
        [self.navigationController pushViewController:calender animated:YES];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
    
}



@end
