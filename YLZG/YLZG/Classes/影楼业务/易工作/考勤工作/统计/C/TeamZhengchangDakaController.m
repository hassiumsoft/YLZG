//
//  TeamZhengchangDakaController.m
//  NewHXDemo
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TeamZhengchangDakaController.h"
#import "TeamZhengchangTableCell.h"
#import <MJExtension.h>

@interface TeamZhengchangDakaController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * tableArr;

@end

@implementation TeamZhengchangDakaController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // 请求数据
    [self loadTeamZhengchangDakaControllerData];
    // 搭建UI
    [self creatTeamZhengchangDakaControllerUI];
}



#pragma mark - 请求数据
- (void)loadTeamZhengchangDakaControllerData{

    _tableArr = [TeamZhengchangdakaModel mj_objectArrayWithKeyValuesArray:_dataArray];
    [self.tableView reloadData];
}


#pragma mark - 搭建UI
- (void)creatTeamZhengchangDakaControllerUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamZhengchangTableCell * cell = [TeamZhengchangTableCell sharedTeamZhengchangTableCell:tableView];
    TeamZhengchangdakaModel * model = _tableArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (NSMutableArray *)tableArr
{
    if (!_tableArr) {
        _tableArr = [[NSMutableArray alloc]init];
    }
    return _tableArr;
}

@end
