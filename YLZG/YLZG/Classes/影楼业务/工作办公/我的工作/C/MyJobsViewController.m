//
//  MyJobsViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MyJobsViewController.h"
#import "CalendarHomeViewController.h"
#import "HTTPManager.h"
#import <MJExtension.h>
#import "ZCAccountTool.h"
#import <MJRefresh.h>
#import <Masonry.h>
#import "MyjobModel.h"
#import "MyJobsTableCell.h"
#import "NormalIconView.h"
#import "MyJobsDetialController.h"

@interface MyJobsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;

@property (copy,nonatomic) NSString *datestr;

@property (strong,nonatomic) NormalIconView *emptyBtn;

@end

@implementation MyJobsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的工作";
    [self setupSubviews];
}

- (void)setupSubviews
{
    // 获取当天日期
    self.datestr = [self getCurrentTime];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"change_calender"] style:UIBarButtonItemStylePlain target:self action:@selector(changeTime)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithDate:self.datestr];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadDataWithDate:(NSString *)dateStr
{
    
    ZCAccount * account = [ZCAccountTool account];
    NSString * url = [NSString stringWithFormat:MyWork_Url, self.datestr, account.userID];
    KGLog(@"url = %@",url);
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (status == 1) {
            NSArray * resultArr = responseObject[@"mywork"];
            if (resultArr.count >= 1) {
                [self.emptyBtn removeFromSuperview];
               self.array = [MyjobModel mj_objectArrayWithKeyValuesArray:resultArr];
                [self.tableView reloadData];
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    
                }];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self loadEmptyView:@"当日暂无工作"];
            }
        }else{
            [self loadEmptyView:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self loadEmptyView:error.localizedDescription];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyJobsTableCell *cell = [MyJobsTableCell sharedMyJobsTableCell:tableView];
    MyjobModel *model = self.array[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyJobsDetialController *myJob = [MyJobsDetialController new];
    myJob.model = self.array[indexPath.row];
    [self.navigationController pushViewController:myJob animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)changeTime
{
    CalendarHomeViewController *calendar = [[CalendarHomeViewController alloc]init];
    [calendar setAirPlaneToDay:365 ToDateforString:nil];
    __weak MyJobsViewController * weakSelf = self;
    calendar.calendarblock = ^(CalendarDayModel *model){
        NSString *chooseDate = [NSString stringWithFormat:@"%@",[model toString]];
        NSString *currentDate = weakSelf.datestr;
        if ([currentDate isEqualToString:chooseDate]) {
            return ;
        }
        [self.array removeAllObjects];
        [self.tableView.mj_header beginRefreshing];
//        [self loadDataWithDate:self.datestr];
    };
    [self.navigationController pushViewController:calendar animated:YES];
}
#pragma mark - 没有数据时
- (void)loadEmptyView:(NSString *)message
{
    CATransition *animation = [CATransition animation];
    animation.duration = 2.f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    // 全部为空值
    self.emptyBtn.label.text = message;
    [self.view addSubview:self.emptyBtn];
    [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
}

- (NormalIconView *)emptyBtn
{
    if (!_emptyBtn) {
        _emptyBtn = [NormalIconView sharedHomeIconView];
        _emptyBtn.iconView.image = [UIImage imageNamed:@"sadness"];
        _emptyBtn.label.numberOfLines = 0;
        _emptyBtn.label.textColor = RGBACOLOR(219, 99, 155, 1);
        _emptyBtn.backgroundColor = [UIColor clearColor];
    }
    return _emptyBtn;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 86;
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
