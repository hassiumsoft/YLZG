//
//  ZhuanfaCountController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/7.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ZhuanfaCountController.h"
#import <MJExtension.h>
#import "FriendDetialController.h"
#import "NormalTableCell.h"
#import "YLZGDataManager.h"
#import <UIImageView+WebCache.h>
#import "CountHeadLabel.h"


@interface ZhuanfaCountController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) UIView *headView;

@end

@implementation ZhuanfaCountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转发统计";
    [self setupSubViews];
}
- (void)setupSubViews
{
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.countModel.personlist.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZhuanfaListModel *zhuanfaModel = self.countModel.personlist[indexPath.row];
    
    NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [cell.xian removeFromSuperview];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel *label = [self CreateNumLabel];
    label.text = zhuanfaModel.times;
    [cell.contentView addSubview:label];
    
    [[YLZGDataManager sharedManager] getOneStudioByUID:zhuanfaModel.uid Block:^(ContactersModel *model) {
        cell.textLabel.text = model.realname;
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"上次转发时间:%@",[self TimeIntToDateStr:zhuanfaModel.create_at]];
        
    }];
    
    return cell;
}

- (UILabel *)CreateNumLabel
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 85, 15, 80, 30)];
    label.textColor = MainColor;
    label.font = [UIFont boldSystemFontOfSize:24];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZhuanfaListModel *listModel = self.countModel.personlist[indexPath.row];
    FriendDetialController *friend = [FriendDetialController new];
    [[YLZGDataManager sharedManager] getOneStudioByUID:listModel.uid Block:^(ContactersModel *model) {
        friend.isRootPush = YES;
        friend.userName = model.name;
        [self.navigationController pushViewController:friend animated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footV = [UIView new];
    footV.backgroundColor = [UIColor clearColor];
    return footV;
}


- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        _headView.backgroundColor = [UIColor whiteColor];
        NSArray *titleArr = @[@"团队人数",@"已转发人数",@"微转发人数"];
        NSArray *numArr = @[self.countModel.all,self.countModel.done,self.countModel.dont];
        
        for (int i = 0; i < titleArr.count; i++) {
            CountHeadLabel *button = [[CountHeadLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 * i, 0, SCREEN_WIDTH, 100)];
            
            button.titleStr = titleArr[i];
            button.numberStr = numArr[i];
            [_headView addSubview:button];
            
            
        }
    }
    return _headView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
        
    }
    return _tableView;
}

@end
