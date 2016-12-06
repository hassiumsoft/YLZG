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
#import <MJExtension/MJExtension.h>
#import <MJRefresh.h>
#import "MyUsedModel.h"
#import "NormalTableCell.h"

@interface MyUsedViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    int currentPage;
}
@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;

@end

@implementation MyUsedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我已使用";
    [self setupSubViews];
}
- (void)setupSubViews
{
    currentPage = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataWithPage:currentPage Nums:1];
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


- (void)getDataWithPage:(int)page Nums:(int)nums
{
    NSString *url = [NSString stringWithFormat:NineMyUsed_Url,[ZCAccountTool account].userID,page,nums];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        int page = [[[responseObject objectForKey:@"page"] description] intValue];
        
        [self.tableView.mj_header endRefreshing];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            NSArray *tempArr = [MyUsedModel mj_objectArrayWithKeyValuesArray:result];
            [self.array addObjectsFromArray:tempArr];
            [self.tableView reloadData];
            
            if (currentPage == page) {
                // 提示没有更多了
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                // 可以继续上拉加载数据
                currentPage++;
                self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self getDataWithPage:currentPage Nums:1];
                }];
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
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
