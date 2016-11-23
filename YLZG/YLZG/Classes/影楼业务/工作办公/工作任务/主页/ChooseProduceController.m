//
//  ChooseProduceController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ChooseProduceController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <Masonry.h>
#import "AddNewTaskProController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ProduceListTableCell.h"
#import <LCActionSheet.h>

@interface ChooseProduceController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *array;


@end

@implementation ChooseProduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择项目";
    [self setupSubViews];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData
{
    NSString *url = [NSString stringWithFormat:TaskProductList_URL,[ZCAccountTool account].userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *result = [responseObject objectForKey:@"result"];
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                
            }];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            if (result.count >= 1) {
                self.array = [TaskProduceListModel mj_objectArrayWithKeyValuesArray:result];
                [self.tableView reloadData];
            }else{
                [self showErrorTips:@"您暂未参与任何项目"];
            }
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showErrorTips:error.localizedDescription];
    }];
}
- (void)setupSubViews
{
    self.view.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addproduce)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}
- (void)addproduce
{
    AddNewTaskProController *add = [AddNewTaskProController new];
    add.ReloadDataBlock = ^(){
        [self loadData];
    };
    [self.navigationController pushViewController:add animated:YES];
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
    ProduceListTableCell *cell = [ProduceListTableCell sharedProduceListCell:tableView];
    cell.proModel = self.array[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TaskProduceListModel *model = self.array[indexPath.section];
    if (self.DidSelectBlock) {
        _DidSelectBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55;
        _tableView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
        _tableView.backgroundColor = self.view.backgroundColor;
        
    }
    return _tableView;
}



@end
