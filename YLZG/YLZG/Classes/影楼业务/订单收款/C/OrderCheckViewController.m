//
//  OrderCheckViewController.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/19.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "OrderCheckViewController.h"
#import "NoDequTableCell.h"
#import "SearchTaoxiController.h"
#import "HomeNavigationController.h"
#import "NormalTableCell.h"
#import "PayMoneyViewController.h"



@interface OrderCheckViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SearOrderDelegate>

{
    BOOL isFirst;
}

/** 客户姓名 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 订单号 */
@property (strong,nonatomic) UILabel *orderNumLabel;
/** 详细 */
@property (strong,nonatomic) UILabel *detialLabel;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;


@property (strong,nonatomic) SearchViewModel *model;


@end

@implementation OrderCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单收款";
    isFirst = YES;
    [self setupSubViews];
    
}

- (void)setupSubViews
{
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArr = @[@"开单号码:",@"姓       名:",@"订  单  号:",@"详       情:",@"确定支付"];
    if (indexPath.row == 0) {
        // 手机号
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        cell.contentLabel.text = self.model.phone;
        cell.textLabel.text = titleArr[indexPath.row];
        
        return cell;
    } else if(indexPath.row == 1){
        // 姓名
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        cell.contentLabel.text = self.model.guestname;
        cell.textLabel.text = titleArr[indexPath.row];
        
        return cell;
    }else if(indexPath.row == 2){
        // 订单号
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        cell.contentLabel.text = self.model.tradeID;
        cell.textLabel.text = titleArr[indexPath.row];
        
        return cell;
    }else if (indexPath.row == 3){
        // 详情
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        if (self.model) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@ ￥%@",self.model.set,self.model.price];
        }
        cell.textLabel.text = titleArr[indexPath.row];
        
        return cell;
    }else{
        // 支付按钮
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [cell.xian removeFromSuperview];
        cell.backgroundColor = self.view.backgroundColor;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArr[indexPath.row] forState:UIControlStateNormal];
        button.backgroundColor = MainColor;
        button.layer.cornerRadius = 6;
        button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [button addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(20, SCREEN_HEIGHT - 55 * 4 - 30 - 64 - 50, SCREEN_WIDTH - 40, 38)];
        [cell addSubview:button];
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 4) {
        SearchTaoxiController *search = [SearchTaoxiController new];
        search.delegate = self;
        [self.navigationController pushViewController:search animated:YES];
    }
}
- (void)checkClick
{
    if (!self.model) {
        [self showErrorTips:@"请先查询订单"];
        return;
    }
    
    PayMoneyViewController *payMoney = [PayMoneyViewController new];
    payMoney.orderID = self.model.tradeID;
    payMoney.price = self.model.price;
    [self.navigationController pushViewController:payMoney animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return SCREEN_HEIGHT - 55 * 4 - 12;
    }else{
        return 55;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - 查询回调
- (void)searchOrderModel:(SearchViewModel *)model
{
    if ([model.price intValue] == 0) {
        [self showErrorTips:@"该订单已付款"];
        [self hideHud:1.5];
        return;
    }
    isFirst = NO;
    self.model = model;
    [self.tableView reloadData];
}
- (void)searchOrder
{
    [self showSuccessTips:@"搜索"];
}
#pragma mark - 懒加载
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 6, SCREEN_WIDTH - 10 - 120, 43)];
        _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _nameLabel;
}
- (UILabel *)orderNumLabel
{
    if (!_orderNumLabel) {
        _orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 6, SCREEN_WIDTH - 10 - 120, 43)];
        _orderNumLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _orderNumLabel;
}
- (UILabel *)detialLabel
{
    if (!_detialLabel) {
        _detialLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 6, SCREEN_WIDTH - 10 - 120, 43)];
        _detialLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _detialLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.rowHeight = 60;
        _tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0);
    }
    return _tableView;
}

@end
