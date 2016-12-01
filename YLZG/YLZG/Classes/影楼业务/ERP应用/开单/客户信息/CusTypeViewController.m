//
//  CusTypeViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/7.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CusTypeViewController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "NormalTableCell.h"

@interface CusTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation CusTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户来源";
    
    [self setupSubViews];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
}
- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
    [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_SelectBlock) {
        _SelectBlock(self.array[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
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
- (void)getData
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:CusTomer_URL,account.userID];
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        KGLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        [self.tableView.mj_header endRefreshing];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count >= 1) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.array = result;
                [self.tableView reloadData];
            }else{
                [self showErrorTips:@"暂无套系类别"];
            }
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.rowHeight = 48;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



@end
