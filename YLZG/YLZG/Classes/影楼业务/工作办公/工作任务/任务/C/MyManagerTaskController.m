//
//  MyManagerTaskController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MyManagerTaskController.h"
#import "TaskListTableCell.h"
#import "TaskDetialViewController.h"

@interface MyManagerTaskController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation MyManagerTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我负责的";
    [self setupSubViews];
}
- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.todayArray.count;
    }else{
        return self.laterArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TaskListModel *model = self.todayArray[indexPath.row];
        TaskListTableCell *cell = [TaskListTableCell sharedTaskListTableCell:tableView];
        model.isMyManager = YES;
        cell.model = model;
        return cell;
    }else{
        TaskListModel *model = self.laterArray[indexPath.row];
        TaskListTableCell *cell = [TaskListTableCell sharedTaskListTableCell:tableView];
        model.isMyManager = YES;
        cell.model = model;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        TaskDetialViewController *detial =[TaskDetialViewController new];
        detial.listModel = self.todayArray[indexPath.row];
        [self.navigationController pushViewController:detial animated:YES];
    }else if(indexPath.section == 1){
        TaskDetialViewController *detial =[TaskDetialViewController new];
        detial.listModel = self.laterArray[indexPath.row];
        [self.navigationController pushViewController:detial animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.todayArray.count == 0) {
            return 0;
        }else{
            return 30;
        }
    } else {
        if (self.laterArray.count == 0) {
            return 0;
        }else{
            return 30;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titleArr = @[@"今日到期",@"即将到期"];
    UIView *headV = [UIView new];
    headV.backgroundColor = self.view.backgroundColor;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.width - 30, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.text = titleArr[section];
    [headV addSubview:titleLabel];
    return headV;
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

- (void)setTodayArray:(NSArray *)todayArray
{
    _todayArray = todayArray;
    [self.tableView reloadData];
}
- (void)setLaterArray:(NSArray *)laterArray
{
    _laterArray = laterArray;
    [self.tableView reloadData];
}


@end
