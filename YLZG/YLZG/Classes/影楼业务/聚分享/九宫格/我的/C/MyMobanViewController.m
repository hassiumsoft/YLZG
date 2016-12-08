//
//  MyMobanViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MyMobanViewController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <MJExtension.h>
#import "UserInfoManager.h"
#import "NineDetialViewController.h"
#import "TeamUsedTableCell.h"
#import <LCActionSheet.h>
#import <MJRefresh.h>
#import "MyMobanModel.h"

@interface MyMobanViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation MyMobanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的模板";
    
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
    cell.myMobanModel = self.array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyMobanModel *usedModel = self.array[indexPath.row];
    
    NineDetialViewController *detial = [NineDetialViewController new];
    detial.isManager = [[UserInfoManager getUserInfo].type intValue] ? YES : NO;
    detial.date = usedModel.date;
    detial.mobanID = usedModel.id;
    detial.title = usedModel.name;
    [self.navigationController pushViewController:detial animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"删除模板" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                // 删除模板
                [self deleteMoban:self.array[indexPath.row] Index:indexPath];
            }
        } otherButtonTitles:@"删除", nil];
        sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
        [sheet show];
    }];
    action.backgroundColor = WechatRedColor;
    return @[action];
}
- (void)deleteMoban:(MyMobanModel *)myModel Index:(NSIndexPath *)path
{
    NSString *url = [NSString stringWithFormat:DeleteMyMoban_Url,[ZCAccountTool account].userID,myModel.id];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        
        if (code == 1) {
            [self.array removeObjectAtIndex:path.row];
            [self.tableView reloadData];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self sendErrorWarning:error.localizedDescription];
    }];
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
    NSString *url = [NSString stringWithFormat:GetMyMoban_Url,[ZCAccountTool account].userID,[self getCurrentTime]];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        
        [self.tableView.mj_header endRefreshing];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count >= 1) {
                self.array = [MyMobanModel mj_objectArrayWithKeyValuesArray:result];
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
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

@end
