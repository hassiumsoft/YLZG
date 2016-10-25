//
//  ShenpiersViewController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/20.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "ShenpiersViewController.h"
#import "StaffTableViewCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "ZCAcCountTool.h"
#import "UserInfoViewController.h"
#import "HTTPManager.h"


@interface ShenpiersViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSArray *array;

@end

@implementation ShenpiersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择审批人";
    [self setupSubViews];
}
#pragma mark - 加载模拟数据
- (void)getData
{
    
    ZCAccount * account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:YLHome_Url, account.userID];
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self.tableView.mj_header endRefreshing];
        if (status == 1) {
            NSArray *array = [responseObject objectForKey:@"result"];
            self.array = [StaffInfoModel mj_objectArrayWithKeyValuesArray:array];
            [self.tableView reloadData];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}

- (void)setupSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 表格相关
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
    StaffTableViewCell *cell = [StaffTableViewCell sharedStaffTableViewCell:tableView];
    StaffInfoModel *model = self.array[indexPath.row];
    cell.model = model;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StaffInfoModel *model = self.array[indexPath.row];
    ZCAccount *account = [ZCAccountTool account];
    if ([model.username isEqualToString:account.username]) {
        UserInfoViewController *userInfo = [[UserInfoViewController alloc]init];
        [self.navigationController pushViewController:userInfo animated:YES];
    }else{
        // 选择审批人
        if ([self.delegate respondsToSelector:@selector(shenpiDelegate:)]) {
            [self.delegate shenpiDelegate:model]; 
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

@end
