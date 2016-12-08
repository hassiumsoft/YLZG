//
//  MyUsedViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MyUsedViewController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import "NineDetialViewController.h"
#import "UserInfoManager.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh.h>
#import "MyUsedModel.h"
#import "TeamUsedTableCell.h"

@interface MyUsedViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation MyUsedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我已使用";
    [self setupSubViews];
}
- (void)setupSubViews
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
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
    TeamUsedTableCell *cell = [TeamUsedTableCell sharedTeamUsedTableCell:tableView];
    cell.myUsedModel = self.array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyUsedModel *usedModel = self.array[indexPath.row];
    
    NineDetialViewController *detial = [NineDetialViewController new];
    detial.isManager = [[UserInfoManager getUserInfo].type intValue] ? YES : NO;
    detial.date = usedModel.date;
    detial.mobanID = usedModel.id;
    detial.title = usedModel.name;
    [self.navigationController pushViewController:detial animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108 - 45)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
        
    }
    return _tableView;
}


- (void)getData
{
    NSString *url = [NSString stringWithFormat:NineMyUsed_Url,[ZCAccountTool account].userID,[self getCurrentTime]];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        
        [self.tableView.mj_header endRefreshing];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count >= 1) {
                self.array = [MyUsedModel mj_objectArrayWithKeyValuesArray:result];
                [self.tableView reloadData];
                
                self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                        
                    }];
                // 提示没有更多了
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                [self showErrorTips:@"没有数据"];
            }
            
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self sendErrorWarning:error.localizedDescription];
    }];
}



@end
