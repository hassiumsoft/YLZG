//
//  YejiViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "YejiViewController.h"
#import "YLZGTitleLabel.h"
#import <PDTSimpleCalendarViewController.h>
#import "YejiDetialViewController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import "StaffYejiModel.h"
#import <MJExtension/MJExtension.h>

@interface YejiViewController ()<PDTSimpleCalendarViewDelegate,UIScrollViewDelegate>


/** 顶部标签滚动栏 */
@property (strong, nonatomic) UIScrollView * titleScrollView;
/** 内容滚动栏 */
@property (strong, nonatomic) UIScrollView * contentScrollView;
/** 标签数组 */
@property (strong, nonatomic) NSArray * titleArray;



@end

@implementation YejiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"业绩榜";
    
    self.titleArray = @[@"前期销售",@"后期销售",@"摄影二次",@"选片二次",@"化妆二次"];
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
    
    NSString *ymd = [self getCurrentAreaDateAndTime];
    NSString *month = [ymd substringWithRange:NSMakeRange(0, 7)];
    self.title = [NSString stringWithFormat:@"业绩榜(%@)",month];
    [self loadDataWithMonth:month];
    
    
}
#pragma mark - 获取数据
- (void)loadDataWithMonth:(NSString *)month
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:YejiURL,month,account.userID];
    [self showHudMessage:@"加载中"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        [self hideHud:0];
        // 告诉子控制器刷新数据
        NSArray *childArray = self.childViewControllers;
        
        if (status == 1) {
            //  @[@"前期", @"后期", @"摄影二次",@"选片二次",@"化妆二次"];
            NSDictionary *result = [responseObject objectForKey:@"result"];
            // 前期
            NSArray *preproArr = [result objectForKey:@"prepro"];
            YejiDetialViewController *qianqiVC = childArray[0];
            qianqiVC.array = [StaffYejiModel mj_objectArrayWithKeyValuesArray:preproArr];
            // 后期
            NSArray *postproArr = [result objectForKey:@"postpro"];
            YejiDetialViewController *houqiVC = childArray[1];
            houqiVC.array = [StaffYejiModel mj_objectArrayWithKeyValuesArray:postproArr];
            // 摄影二次
            NSArray *ptsellArr = [result objectForKey:@"ptsell"];
            YejiDetialViewController *sheyingVC = childArray[2];
            sheyingVC.array = [StaffYejiModel mj_objectArrayWithKeyValuesArray:ptsellArr];
            // 选片二次
            NSArray *sptsellArr = [result objectForKey:@"sptsell"];
            YejiDetialViewController *xuanpianVC = childArray[3];
            xuanpianVC.array = [StaffYejiModel mj_objectArrayWithKeyValuesArray:sptsellArr];
            // 化妆二次
            NSArray *mptsellArr = [result objectForKey:@"mptsell"];
            YejiDetialViewController *huazhuangVC = childArray[4];
            huazhuangVC.array = [StaffYejiModel mj_objectArrayWithKeyValuesArray:mptsellArr];
        }else{
            NSString *message = [responseObject objectForKey:@"message"];
            [self showErrorTips:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self showErrorTips:error.localizedDescription];
    }];
}

/** 添加默认控制器 */
- (void)addDefaultController
{
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:vc.view];
    YLZGTitleLabel *lable = [self.titleScrollView.subviews firstObject];
    lable.scale = 1.0;
}


/** 添加子控制器 */
- (void)addController
{
    for (int i = 0 ; i < self.titleArray.count ;i++){
        YejiDetialViewController * vc = [[YejiDetialViewController alloc] init];
        [self addChildViewController:vc];
    }
}

/** 添加标签 */
- (void)addLabel
{
    CGFloat labelW = SCREEN_WIDTH/5;
    CGFloat labelH = 30;
    CGFloat labelY = 0;
    for (int i = 0; i < self.titleArray.count; i++) {
        CGFloat labelX = i * labelW;
        YLZGTitleLabel * label = [[YLZGTitleLabel alloc] init];
        label.text = self.titleArray[i];
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.font = [UIFont systemFontOfSize:15];
        label.tag = i;
        label.userInteractionEnabled = YES;
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
    titleScrollView.backgroundColor = RGBACOLOR(235, 232, 238, 1);
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.showsVerticalScrollIndicator = NO;
    titleScrollView.y = 0;
    titleScrollView.width = self.view.width;
    titleScrollView.height = 30;
    self.titleScrollView = titleScrollView;
    [self.view addSubview:self.titleScrollView];
}

/** 初始化内容滚动栏 */
- (void)setupContentScrollView
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView * contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.delegate = self;
    contentScrollView.y = CGRectGetMaxY(self.titleScrollView.frame);
    contentScrollView.width = self.view.width;
    
    // 判断是否是点击tabbar中间加号进来的，如果是则不减去tabbar的高度
    CGFloat scrollViewH;
    scrollViewH = self.view.height - 64 - self.titleScrollView.height - self.tabBarController.tabBar.height;
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
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    
    // 滚动标题栏
    YLZGTitleLabel *titleLable = (YLZGTitleLabel *)self.titleScrollView.subviews[index];
    
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
    YejiDetialViewController *newsVc = self.childViewControllers[index];
    newsVc.index = index;
    
    [self.titleScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            YLZGTitleLabel *temlabel = self.titleScrollView.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = scrollView.bounds;
    [self.contentScrollView addSubview:newsVc.view];
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
#pragma mark - 却换日期
- (void)changeDate
{
    PDTSimpleCalendarViewController *calender = [[PDTSimpleCalendarViewController alloc]init];
    calender.title = @"点击选择月份";
    calender.delegate = self;
    calender.overlayTextColor = MainColor;
    calender.weekdayHeaderEnabled = YES;
    calender.firstDate = [NSDate dateWithHoursBeforeNow:8*30*24];
    calender.lastDate = [NSDate date];
    [self.navigationController pushViewController:calender animated:YES];
}

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    KGLog(@"date = %@",date);
    
    
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSString *time = [NSString stringWithFormat:@"%@",nextDay];
    NSString *changeMonth = [time substringWithRange:NSMakeRange(0, 7)];
    self.title = [NSString stringWithFormat:@"业绩榜：(%@)",changeMonth];
    
    [self loadDataWithMonth:changeMonth];
    
    [controller.navigationController popViewControllerAnimated:YES];
    
    
}


@end
