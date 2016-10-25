//
//  TodayOrderViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TodayOrderViewController.h"
#import <PDTSimpleCalendarViewController.h>
#import "TodayOrderModel.h"
#import <MJExtension/MJExtension.h>
#import <Masonry.h>
#import "TodayOrderCell.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"

@interface TodayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,TodayOrderCellDelegate,PDTSimpleCalendarViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSString *date;

@property (copy,nonatomic) NSArray *array;

@property (strong,nonatomic) UIImageView *emptyImageV;


@end

@implementation TodayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"今日订单";
    self.date = [self todayDate];
    [self loadData];
    
}

- (void)loadData
{
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:TodayOrder_Url,self.date,account.userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int status = [[[responseObject objectForKey:@"code"] description ] intValue];
        if (status == 1) {
            NSArray *tempArr = [responseObject objectForKey:@"result"];
            if (tempArr.count < 1) {
                // 没有订单
                self.array = [TodayOrderModel mj_objectArrayWithKeyValuesArray:tempArr];
                [self loadEmptyView];
                [self.tableView reloadData];
                
            }else{
                // 有订单
                self.array = [TodayOrderModel mj_objectArrayWithKeyValuesArray:tempArr];
                [self.emptyImageV removeFromSuperview];
                
                [self setupSubViews];
                
                
            }
        }else{
            [self loadEmptyView];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
    
    
}


- (void)loadEmptyView
{
    [self.tableView removeFromSuperview];
    
    [self.view addSubview:self.emptyImageV];
    [self.emptyImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@180);
        make.height.equalTo(@200);
    }];
    
}
- (UIImageView *)emptyImageV
{
    if (!_emptyImageV) {
        _emptyImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_icon"]];
    }
    return _emptyImageV;
}

- (void)setupSubViews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayOrderCell *cell = [TodayOrderCell sharedTodayOrderCell:tableView];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    TodayOrderModel *model = self.array[indexPath.row];
    cell.model = model;
    return cell;
}
#pragma mark - TodayOrderCellDelegate
- (void)openPhoneWebView:(TodayOrderModel *)model
{
    if (model.phone.length >= 11) {
        NSString *phone = [model.phone substringWithRange:NSMakeRange(0, 11)];
        NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]];
        UIWebView *phoneWeb = [[UIWebView alloc]initWithFrame:CGRectZero];
        [phoneWeb loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
        [self.view addSubview:phoneWeb];
    }else{
        [self sendErrorWarning:@"该顾客留下的电话号码有误"];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"change_calender"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (NSString *)todayDate
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *returnStr = [formatter stringFromDate:[NSDate date]];
    
    return returnStr;
}

#pragma mark - 选择日期
- (void)rightBarButtonItemClicked
{
    PDTSimpleCalendarViewController *calender = [[PDTSimpleCalendarViewController alloc]init];
    calender.title = @"点击选择日期";
    calender.delegate = self;
    calender.overlayTextColor = MainColor;
    calender.weekdayHeaderEnabled = YES;
    calender.firstDate = [NSDate dateWithHoursBeforeNow:8*30*24];
    calender.lastDate = [NSDate date];
    [self.navigationController pushViewController:calender animated:YES];
    
    
}
- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    
    [self.tableView endEditing:YES];
    
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSString *time = [NSString stringWithFormat:@"%@",nextDay];
    NSString *timeC = [time substringWithRange:NSMakeRange(0, 10)];
    self.date = timeC;
    self.title = self.date;
    [controller.navigationController popViewControllerAnimated:YES];
    [self loadData];
    [self.tableView reloadData];
}


@end
