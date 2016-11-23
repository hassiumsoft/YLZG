//
//  MyCareTaskController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MyCareTaskController.h"
#import "TaskListModel.h"
#import "TaskDetialViewController.h"
#import "TaskListTableCell.h"

@interface MyCareTaskController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation MyCareTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我关注的";
//    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];
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
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskListModel *model = self.array[indexPath.row];
    TaskListTableCell *cell = [TaskListTableCell sharedTaskListTableCell:tableView];
    model.isMyManager = NO;
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TaskDetialViewController *detial =[TaskDetialViewController new];
    detial.listModel = self.array[indexPath.row];
    [self.navigationController pushViewController:detial animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [[UIView alloc]init];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.rowHeight = 60;
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    }
    return _tableView;
}
- (void)setArray:(NSArray *)array
{
    _array = array;
}

@end
