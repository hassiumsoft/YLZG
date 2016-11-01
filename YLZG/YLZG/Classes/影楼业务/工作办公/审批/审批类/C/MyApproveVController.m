//
//  MyApproveVController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MyApproveVController.h"
#import "ZCAccountTool.h"
#import "NoDequTableCell.h"
#import "AppearHeadView.h"
#import "QingjiaViewController.h"
#import "WaichuViewController.h"
#import "WuPingViewController.h"
#import "CommonApplyController.h"
#import "ApproveListViewController.h"


@interface MyApproveVController ()<UITableViewDelegate,UITableViewDataSource>

@property (copy,nonatomic) NSArray *array;
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation MyApproveVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审批";
    [self setupSubViews];
}
#pragma mark - 表格
- (void)setupSubViews
{
    self.array = @[@"请假",@"外出",@"物品领用",@"通用"];
    [self.view addSubview:self.tableView];
    
    AppearHeadView *headView = [[AppearHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    headView.ClickBlock = ^(AppearType type){
        switch (type) {
            case WaitAppearType:
            {
                ApproveListViewController *app = [ApproveListViewController new];
                app.index = 0;
                app.title = @"待我审批";
                [self.navigationController pushViewController:app animated:YES];
                break;
            }
            case AppearedType:
            {
                ApproveListViewController *app = [ApproveListViewController new];
                app.title = @"我已审批";
                app.index = 1;
                [self.navigationController pushViewController:app animated:YES];
                break;
            }
            case MyApplyType:
            {
                ApproveListViewController *app = [ApproveListViewController new];
                app.index = 2;
                app.title = @"我发起的";
                [self.navigationController pushViewController:app animated:YES];
                break;
            }
                
            default:
                break;
        }
    };
    self.tableView.tableHeaderView = headView;
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
    NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        QingjiaViewController *qingjia = [QingjiaViewController new];
        [self.navigationController pushViewController:qingjia animated:YES];
    } else if(indexPath.row == 1){
        WaichuViewController *waichu = [WaichuViewController new];
        [self.navigationController pushViewController:waichu animated:YES];
    }else if (indexPath.row == 2){
        WuPingViewController *wuping = [WuPingViewController new];
        [self.navigationController pushViewController:wuping animated:YES];
    }else{
        CommonApplyController *comm = [CommonApplyController new];
        [self.navigationController pushViewController:comm animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [[UIView alloc]initWithFrame:CGRectNull];
    head.backgroundColor = self.view.backgroundColor;
    return head;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}
@end
