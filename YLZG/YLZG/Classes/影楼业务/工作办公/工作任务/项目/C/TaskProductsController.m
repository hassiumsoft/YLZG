//
//  TaskProductsController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskProductsController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import "TaskProductTableCell.h"
#import "AddNewTaskProController.h"

@interface TaskProductsController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation TaskProductsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"影楼项目";
    [self setupSubViews];
    
    [self loadData];
    
}
- (void)loadData
{
    NSString *url = [NSString stringWithFormat:TaskProductList_URL,[ZCAccountTool account].userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskProductTableCell *cell = [TaskProductTableCell sharedTaskProductCell:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddNewTaskProController *add = [AddNewTaskProController new];
    [self.navigationController pushViewController:add animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 120;
        _tableView.backgroundColor = self.view.backgroundColor;
        
    }
    return _tableView;
}

@end
