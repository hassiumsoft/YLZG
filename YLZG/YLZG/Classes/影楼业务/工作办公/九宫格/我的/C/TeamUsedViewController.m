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
#import "NormalTableCell.h"


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
    self.view.backgroundColor = [UIColor whiteColor];
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
    TeamUsedModel *listModel = self.array[indexPath.section];
    cell.textLabel.text = listModel.date;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor whiteColor];
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
