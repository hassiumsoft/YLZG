//
//  MonthFinanceVController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/2.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "MonthFinanceVController.h"
#import "MonthInComeController.h"
#import "MonthOutComeController.h"
//#import <PDTSimpleCalendarViewController.h>
#import "ZCAccountTool.h"
#import "InComeModel.h"
#import "MonthPicerView.h"
#import "OutComeModel.h"
#import "TitleLabel.h"
#import <Masonry.h>
#import <MJExtension.h>
#import "HTTPManager.h"


#define NavHeight 64
#define NavTitleW 50
#define NavTitleH 25

@interface MonthFinanceVController ()<UIScrollViewDelegate>
{
    BOOL isReloadData; // 是否重新加载📚数据
}
/** 标题view */
@property (strong, nonatomic) UIView  * titleView;
/** 标题数组 */
@property (strong, nonatomic) NSArray * titleArray;
/** title指示器 */
@property (strong, nonatomic) UIView * indicaterView;
/** 内容滚动视图 */
@property (strong, nonatomic) UIScrollView * contentScrollView;
/** 当前选中的按钮 */
@property (strong, nonatomic) UIButton * selectedButton;
/** 子控制器 */
@property (strong,nonatomic) MonthInComeController *incomeVC;
/** 子控制器 */
@property (strong,nonatomic) MonthOutComeController *outcomeVC;


/** 月份 */
@property (copy,nonatomic) NSString *changeMonth;
/** 收入模型 */
@property (strong,nonatomic) InComeModel *inModel;
/** 支出模型 */
@property (strong,nonatomic) OutComeModel *outModel;


@end

@implementation MonthFinanceVController

static CGFloat const EYWTitleWidth = 60;
static CGFloat const EYWTitleHeight = 44;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@"月收入", @"月支出"];
    
    self.title = @"本月财务";
    isReloadData = NO;
    NSString *ymd = [self getCurrentAreaDateAndTime];
    self.changeMonth = [ymd substringWithRange:NSMakeRange(0, 7)];
    [self loadData:self.changeMonth];
    
}

#pragma mark - 请求数据
- (void)loadData:(NSString *)month
{
    
    [self showHudMessage:@"加载中···"];
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/monthfinance/query?date=%@&uid=%@",self.changeMonth,account.userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        [self hideHud:0];
        if (status == 1) {
            
            NSDictionary *incomeDic = [responseObject objectForKey:@"in"];
            NSDictionary *outcomeDic = [responseObject objectForKey:@"out"];
            self.inModel = [InComeModel mj_objectWithKeyValues:incomeDic];
            self.outModel = [OutComeModel mj_objectWithKeyValues:outcomeDic];
            
            /** 添加子控制器 */
            [self addController];
            
            /** 添加标题 */
            [self addLabel];
            
            /** 初始化内容滚动栏 */
            [self setupContentScrollView];
            
        }else{
            NSString *message = [responseObject objectForKey:@"message"];
            KGLog(@"message = %@",message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
    
}


/** 初始化内容滚动栏 */
- (void)setupContentScrollView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView * contentScrollView = [[UIScrollView alloc] init];
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.backgroundColor = [UIColor whiteColor];
    contentScrollView.delegate = self;
    contentScrollView.frame = self.view.bounds;
    contentScrollView.contentSize = CGSizeMake(self.view.width * self.titleArray.count, 0);
    contentScrollView.pagingEnabled = YES;
    self.contentScrollView = contentScrollView;
    [self.view addSubview:self.contentScrollView];
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentScrollView];
}


/** 添加子控制器 */
- (void)addController
{
    self.incomeVC.inModel = self.inModel;
    self.incomeVC.month = self.changeMonth;
    [self addChildViewController:self.incomeVC];
    
    self.outcomeVC.outModel = self.outModel;
    self.outcomeVC.month = self.changeMonth;
    [self addChildViewController:self.outcomeVC];
    
    if (isReloadData) {
        [self.incomeVC reloadData];
        [self.outcomeVC reloadData];
    }
}

- (MonthInComeController *)incomeVC
{
    if (!_incomeVC) {
        _incomeVC = [[MonthInComeController alloc]init];
    }
    return _incomeVC;
}
- (MonthOutComeController *)outcomeVC
{
    if (!_outcomeVC) {
        _outcomeVC = [[MonthOutComeController alloc]init];
    }
    return _outcomeVC;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titleView.subviews[index]];
}

- (void)titleClick:(UIButton *)button
{
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicaterView.width = button.titleLabel.width;
        self.indicaterView.centerX = button.centerX;
    }];
    
    // 滚动
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = button.tag * self.contentScrollView.width;
    [self.contentScrollView setContentOffset:offset animated:YES];
}



/** 添加标题 */
- (void)addLabel
{
    // 标题栏整体
    UIView * titleView = [[UIView alloc] init];
    titleView.width = EYWTitleWidth * self.titleArray.count;
    titleView.height = EYWTitleHeight;
    self.titleView = titleView;
    self.navigationItem.titleView = self.titleView;
    
    // title指示器
    UIView * indicaterView = [[UIView alloc] init];
    indicaterView.backgroundColor = [UIColor whiteColor];
    indicaterView.height = 2;
    indicaterView.y = self.titleView.height - indicaterView.height;
    indicaterView.width = [self.titleArray[0] boundingRectWithSize:CGSizeMake(EYWTitleWidth, EYWTitleHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil].size.width;
    indicaterView.centerX = [self.titleView.subviews firstObject].centerX;
    self.indicaterView = indicaterView;
    
    CGFloat labelW = EYWTitleWidth;
    CGFloat labelH = EYWTitleHeight - 1;
    CGFloat labelY = 0;
    for (int i = 0; i < self.titleArray.count; i++) {
        CGFloat labelX = i * labelW;
        UIButton * button = [[UIButton alloc] init];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(labelX, labelY, labelW, labelH);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = i;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleView addSubview:button];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicaterView.width = button.titleLabel.width;
            self.indicaterView.centerX = button.centerX;
        }
    }
    
    [self.titleView addSubview:self.indicaterView];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"change_calender"] style:UIBarButtonItemStylePlain target:self action:@selector(changeMonths)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}
#pragma mark - 切换月份
- (void)changeMonths
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MonthPicerView *datePicker = [[MonthPicerView alloc]initWithFrame:keyWindow.bounds];
    datePicker.SelectDateBlock = ^(NSString *selectDate){
        self.changeMonth = selectDate;
        isReloadData = YES;
        [self loadData:self.changeMonth];
    };
    [keyWindow addSubview:datePicker];
    
}
@end
