//
//  TodayFinanceController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TodayFinanceController.h"
#import <PDTSimpleCalendarViewController.h>
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import "QiaodaoCountButton.h"
#import "FinacialAnalysesCell.h"
#import <MJExtension.h>
#import "FinancialDetailCell.h"
#import "FinanceModel.h"


#define backColor [UIColor colorWithRed:0.027 green:0.557 blue:0.000 alpha:1.000]

@interface TodayFinanceController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,PDTSimpleCalendarViewDelegate>
{
    UIView * xianView;
}

@property (nonatomic, strong) UITableView * tableView;
/************ 第一行 ************/
/** 头视图底部的view */
@property (nonatomic, strong) UIView * headView;

@property (nonatomic, strong) QiaodaoCountButton * dateButton;

/** 中间的View */
@property (nonatomic, strong) UIView * middleView;

/** 收入渐增时间器 */
@property (strong,nonatomic) NSTimer *pointTimer;

/************ 头视图按钮切换 ************/
@property (nonatomic, strong) UIView * btnBackView;
/** 切换按钮 */
@property (nonatomic, strong) UIButton * headButton;
/** 按钮底部的灰色线 */
@property (nonatomic, strong) UIView * lineView;

/** 数组 */
@property (nonatomic, strong) NSMutableArray * dataSource1;
@property (nonatomic, strong) NSMutableArray * dataSource2;
// 标记视图切换的index
@property (nonatomic, assign) NSInteger selectButtonIndex;
// 字典
@property (nonatomic, strong) FinanceModel *financeModel;

@property (nonatomic, strong) NSString *changeStr;

@end

@implementation TodayFinanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日财务";
    // 初始化
    [self selfInitSCXFinancialViewControllerVC];
    // 请求数据
    [self loadSCXFinancialViewControllerData];
}

#pragma mark - 初始化
- (void)selfInitSCXFinancialViewControllerVC{
    self.dataSource1 = [[NSMutableArray alloc] init];
    self.dataSource2 = [[NSMutableArray alloc] init];
    
    
    // 日期
    _dateButton = [QiaodaoCountButton shareqiaodaocountBtn];
    _dateButton.label.text = [self getCurrentTime];
}


#pragma mark - 请求数据
- (void)loadSCXFinancialViewControllerData{
    
    ZCAccount * accout = [ZCAccountTool account];
    NSString * url = [NSString stringWithFormat:Financial_Url, _dateButton.label.text, accout.userID];
    [self showHudMessage:@"加载中···"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        KGLog(@"responseObject = %@",responseObject);
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        [self hideHud:0];
        if (status == 1) {
            // 第一组数据
            self.financeModel = [FinanceModel mj_objectWithKeyValues:responseObject[@"finance"]];
            // 第二组数据
            NSArray * detailArray = responseObject[@"details"];
            self.dataSource2 = [FinacialDetailModel mj_objectArrayWithKeyValuesArray:detailArray];
            //                NSLog(@"$$$$$$$$$$$$$$$%@",self.dataSource2);
            // 搭建UI
            [self.tableView removeFromSuperview];
            
            [self creatSCXFinancialViewControllerUI];
            [self.tableView reloadData];
            
        }else{
            [self sendErrorWarning:@"获取失败"];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}

#pragma mark - 搭建UI
- (void)creatSCXFinancialViewControllerUI{
    // 搭建UI
    [self createUI];
    // 搭建tableview
    [self createTableview];
}

#pragma mark -搭建UI相关
- (void)createUI {
    
    /** 第一行 */
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 152)];
    _headView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_headView];
    // 日期
    
    _dateButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    
    [_dateButton addTarget:self action:@selector(dateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:_dateButton];
    
    
    /** 第二行 */
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_dateButton.frame)+10, SCREEN_WIDTH, 88)];
    _middleView.backgroundColor = [UIColor whiteColor];
    [self.headView addSubview:_middleView];
    
    NSArray * titleArr = @[@"总收入", @"总支出", @"净收入", self.financeModel.income, self.financeModel.expend, self.financeModel.netin];
    for (int i = 0; i < titleArr.count; i++) {
        UILabel * label = [self getLabelFrame:CGRectMake(30+ SCREEN_WIDTH/3*(i%3), _middleView.height/2 * (i/3) , SCREEN_WIDTH/3 -20, _middleView.height/2) andText:titleArr[i]];
        [_middleView addSubview:label];
        if (i < 2) {
            UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)-10, 10, 1, 66)];
            imageV.image = [UIImage imageNamed:@"xushuxian"];
            [_middleView addSubview:imageV];
        }
    }
}

#pragma mark -搭建tableview相关
- (void)createTableview {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = _headView;
    [self.view addSubview:_tableView];
}

/**
 时间相关
 */
#pragma mark -选择时间
- (void)dateButtonClicked:(UIBarButtonItem *)item {
    
    PDTSimpleCalendarViewController *calender = [[PDTSimpleCalendarViewController alloc]init];
    calender.title = @"选择日期";
    calender.delegate = self;
    calender.overlayTextColor = MainColor;
    calender.weekdayHeaderEnabled = YES;
    calender.firstDate = [NSDate dateWithHoursBeforeNow:8*30*24];
    calender.lastDate = [NSDate date];
    [self.navigationController pushViewController:calender animated:YES];
    
}


/**
 *   label封装
 */
- (UILabel *)getLabelFrame:(CGRect)frame andText:(NSString *)text {
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:16];
    label.text = text;
    return label;
}

#pragma mark -表格相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_selectButtonIndex == 0) {
        return 1;
    }else if (_selectButtonIndex == 1) {
        return _dataSource2.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectButtonIndex == 0) {
        FinacialAnalysesCell * acell = [FinacialAnalysesCell sharedFinacialAnalysesCell:tableView];
        acell.bingtuView.model = self.financeModel;
        
        //问题未解决:会出现复用问题
        //        NSArray * arr = @[[NSString stringWithFormat:@"   定金  %@", self.finDic[@"deposit"]], [NSString stringWithFormat:@"   补款  %@", self.finDic[@"extra"]], [NSString stringWithFormat:@"   二销  %@", self.finDic[@"tsell"]], [NSString stringWithFormat:@"   其他  %@", self.finDic[@"other"]]];
        //        [acell createCell:arr];
        acell.depositLabel.text = [NSString stringWithFormat:@"   定金  %@", self.financeModel.deposit];
        acell.extraLabel.text = [NSString stringWithFormat:@"   补款  %@", self.financeModel.extra];
        acell.tsellLabel.text = [NSString stringWithFormat:@"   二销  %@", self.financeModel.tsell];
        acell.otherLabel.text = [NSString stringWithFormat:@"   其他  %@", self.financeModel.other];
        
        tableView.rowHeight = 400;
        return acell;
        
    }else  {
        
        FinancialDetailCell * cell = [FinancialDetailCell sharedFinancialDetailCell:tableView];
        tableView.rowHeight = 80;
        FinacialDetailModel * model = _dataSource2[indexPath.row];
        cell.model = model;
        return cell;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    _btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_middleView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-_middleView.height-20)];
    _btnBackView.backgroundColor = [UIColor whiteColor];
    /************ 财务分析 ************/
    NSArray * titleArr = @[@"财务结构", @"财务明细"];
    for (int i = 0; i < titleArr.count; i++) {
        _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headButton.frame = CGRectMake(SCREEN_WIDTH/2 * i, 0, SCREEN_WIDTH/2, 41);
        _headButton.tag = i + 10;
        [_headButton setTitle:titleArr[i] forState:UIControlStateNormal];
        _headButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_headButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_headButton setTitleColor:backColor forState:UIControlStateSelected];
        [_headButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnBackView addSubview:_headButton];
        // 添加下划线
        xianView  = [[UIView alloc] initWithFrame:CGRectMake(10 + SCREEN_WIDTH/2 *i, CGRectGetMaxY(_headButton.frame), SCREEN_WIDTH/2-20, 2)];
        xianView.backgroundColor = backColor;
        xianView.tag = 20 + i;
        [self.btnBackView addSubview:xianView];
        
        if (i == _selectButtonIndex) {
            _headButton.selected = YES;
        }else {
            [xianView setHidden:YES];
        }
    }
    UILabel * grayLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
    grayLine.backgroundColor = [UIColor colorWithRed:0.918 green:0.910 blue:0.918 alpha:1.000];
    [self.btnBackView addSubview:grayLine];
    
    
    return _btnBackView;
}

- (void)buttonClicked:(UIButton *)sender {
    _selectButtonIndex = sender.tag-10;
    
    // 按钮点击切换
    for (int i = 0; i < 2; i++) {
        UIButton * btn = (UIButton *)[self.view viewWithTag:10+i];
        btn.selected = NO;
    }
    sender.selected = YES;
    
    // 线条的切换
    UIView * view1 = (UIView *)[self.view viewWithTag:20];
    UIView * view2 = (UIView *)[self.view viewWithTag:21];
    
    switch (sender.tag) {
        case 10:
        {
            [view1 setHidden:NO];
            [view2 setHidden:YES];
        }
            break;
        case 11:
        {
            [view1 setHidden:YES];
            [view2 setHidden:NO];
        }
            break;
            
        default:
            break;
    }
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    KGLog(@"date = %@",date);
    [self.tableView endEditing:YES];
    NSDate *currentDate = [NSDate date];
    int result = [self compareOneDay:date withAnotherDay:currentDate];
    if (result == -1) {
        [self showErrorTips:@"不能先于当前日期"];
        return;
    }
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSString *time = [NSString stringWithFormat:@"%@",nextDay];
    NSString *timeC = [time substringWithRange:NSMakeRange(0, 10)];
    self.changeStr = [NSString stringWithFormat:@"%@",timeC];  // 选中的年月日
    self.dateButton.label.text = [NSString stringWithFormat:@"%@",timeC];  // 选中的年月日
    [controller.navigationController popViewControllerAnimated:YES];
    [self loadSCXFinancialViewControllerData];
    [self.tableView reloadData];
}
#pragma mark - 比较2各日期的先后顺序
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    //    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedAscending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedDescending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}


@end
