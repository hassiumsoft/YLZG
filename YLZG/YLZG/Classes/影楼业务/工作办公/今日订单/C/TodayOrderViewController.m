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
#import <MJRefresh.h>
#import "TodayOrderCell.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import "UserInfoManager.h"

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
    [self setupSubViews];
    [self loadEmptyView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)loadData
{
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:TodayOrder_Url,self.date,account.userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        int status = [[[responseObject objectForKey:@"code"] description ] intValue];
        if (status == 1) {
            NSArray *tempArr = [responseObject objectForKey:@"result"];
            if (tempArr.count < 1) {
                // 没有订单
                self.array = [TodayOrderModel mj_objectArrayWithKeyValuesArray:tempArr];
                [self.tableView reloadData];
                self.emptyImageV.hidden = NO;
                
            }else{
                // 有订单
                
                self.array = [TodayOrderModel mj_objectArrayWithKeyValuesArray:tempArr];
                [self.tableView reloadData];
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    
                }];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.emptyImageV.hidden = YES;
            }
        }else{
            self.array = @[];
            [self.tableView reloadData];
            [self.tableView.mj_footer removeFromSuperview];
            self.emptyImageV.hidden = NO;
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showErrorTips:error.localizedDescription];
    }];
    
    
}


- (void)loadEmptyView
{
    self.emptyImageV.hidden = YES;
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
    self.tableView.contentInset = UIEdgeInsetsMake(2, 0, 0, 0);
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
#pragma mark - TodayOrderCellDelegate
- (void)openPhoneWebView:(TodayOrderModel *)model
{
    UserInfoModel *userModel = [UserInfoManager getUserInfo];
    if ([userModel.vcip intValue] == 1) {
        NSString *phone;
        if (model.phone.length > 11) {
            phone = [model.phone substringWithRange:NSMakeRange(model.phone.length - 11, 11)];
        }else{
            phone = model.phone;
        }
        NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]];
        UIWebView *phoneWeb = [[UIWebView alloc]initWithFrame:CGRectZero];
        [phoneWeb loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
        [self.view addSubview:phoneWeb];
    }else{
        [self sendErrorWarning:@"当前账号暂无权限，必要情况请联系管理员。"];
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
    calender.title = @"查看往日订单";
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
