//
//  SelectTaskFuzerController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SelectTaskFuzerController.h"
#import "StaffTableViewCell.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "ZCAcCountTool.h"
#import "UserInfoViewController.h"
#import "HTTPManager.h"

@interface SelectTaskFuzerController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation SelectTaskFuzerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}
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
            if (array.count >= 1) {
                self.array = [StaffInfoModel mj_objectArrayWithKeyValuesArray:array];
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    
                }];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView reloadData];
            }
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
        if (self.SelectBlock) {
            _SelectBlock(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}


@end
