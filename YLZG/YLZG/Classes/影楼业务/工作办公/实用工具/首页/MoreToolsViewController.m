//
//  MoreToolsViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MoreToolsViewController.h"
#import "ToolsModel.h"
#import "ToolsTableViewCell.h"
#import "NormalTableCell.h"
#import <Masonry.h>
#import <MJExtension/MJExtension.h>


@interface MoreToolsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSMutableArray *array;

@end

@implementation MoreToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实用工具";
    [self setupSubViews];
    
}
- (void)setupSubViews
{
    NSDictionary *deviceDic = @{@"appName":@"汽车定位器",@"appDetial":@"适用于摄影团队外出时监控行驶轨迹",@"appImageName":@"cl_dw"};
    ToolsModel *model1 = [ToolsModel mj_objectWithKeyValues:deviceDic];
    [self.array addObject:model1];
    
    
    NSDictionary *hospitolDic = @{@"appName":@"医院管理系统",@"appDetial":@"近期推出",@"appImageName":@"yy_xt"};
    ToolsModel *model2 = [ToolsModel mj_objectWithKeyValues:hospitolDic];
    [self.array addObject:model2];
    
    
    [self.view addSubview:self.tableView];
    
    UILabel * footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    footer.backgroundColor = self.view.backgroundColor;
    footer.numberOfLines = 2;
    footer.text = @"CopyRight © 2016\r智诚科技(北京实验室)";
    footer.textAlignment = NSTextAlignmentCenter;
    footer.textColor = [UIColor grayColor];
    footer.font = [UIFont fontWithName:@"Iowan Old Style" size:12];
    self.tableView.tableFooterView = footer;
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
    ToolsModel *model = self.array[indexPath.row];
    if (indexPath.row == 0) {
        ToolsTableViewCell *cell = [ToolsTableViewCell sharedToolsCell:tableView];
        cell.DidSelectBlock = ^(){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/jing-zhun-ding-wei/id689238118?mt=8"]];
        };
        cell.model = model;
        return cell;
    }else{
        ToolsTableViewCell *cell = [ToolsTableViewCell sharedToolsCell:tableView];
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
