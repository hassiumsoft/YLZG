//
//  ChooseMemVController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/15.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "ChooseMemVController.h"
#import "MutliChoceStaffCell.h"
#import <MJRefresh.h>
#import "ZCAccountTool.h"
#import "StaffInfoModel.h"
#import <MJExtension.h>
#import "HTTPManager.h"


@interface ChooseMemVController ()<UITableViewDelegate,UITableViewDataSource>

/** 已选中的数组 */
@property (strong,nonatomic) NSMutableArray *chooseArray;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;

@end

@implementation ChooseMemVController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"选择考勤组员";
    
    
    [self setupTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    UIButton *allChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    [allChoose setTitle:@"全选" forState:UIControlStateNormal];
    [allChoose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    allChoose.frame = CGRectMake(self.view.width/2 - 35, self.view.height - 64 - 80, 60, 60);
    allChoose.layer.cornerRadius = 30;
    allChoose.layer.shadowOffset =  CGSizeMake(4, 4);
    allChoose.layer.shadowOpacity = 0.8;
    allChoose.layer.shadowRadius = 4.f;
    allChoose.layer.shadowColor =  [UIColor blackColor].CGColor;
    allChoose.backgroundColor = MainColor;
    allChoose.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [allChoose addBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton *sender) {
        if (self.array.count >= 1) {
            for (StaffInfoModel *model in self.array) {
                model.isSelected = YES;
            }
            
            [self.tableView reloadData];
            
        }else{
            [MBProgressHUD showError:@"没有数据"];
        }
    }];
    [self.view addSubview:allChoose];
}


- (void)setupTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 55;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(2, 0, 0, 0);
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MutliChoceStaffCell *cell = [MutliChoceStaffCell sharedMutliChoceStaffCell:tableView];
    StaffInfoModel *model = self.array[indexPath.row];
    model.index = indexPath.row;
    cell.model = model;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StaffInfoModel *model = self.array[indexPath.row];
    NSLog(@"model.index = %ld",model.index);
    
    if (model.isSelected) {
        model.isSelected = NO;
    }else{
        model.isSelected = YES;
    }
    [self.tableView reloadData];
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


- (void)doneAction
{
    for (StaffInfoModel *model in self.array) {
        if (model.isSelected) {
            [self.chooseArray addObject:model];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(chooseMemWithArray:)]) {
        [self.delegate chooseMemWithArray:self.chooseArray];
        [self dismiss];
    }
}

#pragma mark - 加载模拟数据
- (void)getData
{
    
    ZCAccount * account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:YLHome_Url, account.userID];
    
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self.tableView.mj_header endRefreshing];
        if (code == 1) {
            // 获取成功 sid：店铺员工ID。type：1是店长、0是店员
            NSArray *array = [responseObject objectForKey:@"result"];
            self.array = [StaffInfoModel mj_objectArrayWithKeyValuesArray:array];
            [self.tableView reloadData];
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                
            }];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self sendErrorWarning:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}
- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableArray *)chooseArray
{
    if (!_chooseArray) {
        _chooseArray = [NSMutableArray array];
    }
    return _chooseArray;
}

@end
