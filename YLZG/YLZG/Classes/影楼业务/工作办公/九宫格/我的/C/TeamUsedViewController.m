//
//  TeamUsedViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TeamUsedViewController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh.h>
#import "TeamUsedModel.h"
#import "TeamUsedTableCell.h"


@interface TeamUsedViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation TeamUsedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团队已用";
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TeamUsedModel *usedModel = self.array[section];
    return usedModel.lists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamUsedTableCell *cell = [TeamUsedTableCell sharedTeamUsedTableCell:tableView];
    TeamUsedModel *usedModel = self.array[indexPath.section];
    TeamUsedListModel *listsModel = usedModel.lists[indexPath.row];
    cell.model = listsModel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TeamUsedModel *usedModel = self.array[section];
    UIView *headV = [UIView new];
    headV.backgroundColor = NorMalBackGroudColor;
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 35, 2, 70, 21)];
    headLabel.backgroundColor = MainColor;
    headLabel.text = usedModel.date;
    headLabel.font = [UIFont systemFontOfSize:11];
    headLabel.textColor = [UIColor whiteColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    headLabel.layer.masksToBounds = YES;
    headLabel.layer.cornerRadius = 3;
    [headV addSubview:headLabel];
    
    return headV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = self.view.backgroundColor;
    return footV;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108 - 45)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        
    }
    return _tableView;
}


- (void)getData
{
    NSString *url = [NSString stringWithFormat:NineTeamUsed_Url,[ZCAccountTool account].userID,[self getCurrentTime]];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self.tableView.mj_header endRefreshing];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            self.array = [TeamUsedModel mj_objectArrayWithKeyValuesArray:result];
            [self.tableView reloadData];
            
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self sendErrorWarning:error.localizedDescription];
    }];
}


@end
