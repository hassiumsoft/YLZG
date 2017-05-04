//
//  SearchContacterController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SearchContacterController.h"
#import "ContactTableViewCell.h"
#import "ZCAccountTool.h"
#import "UserInfoViewController.h"
#import "FriendDetialController.h"

@interface SearchContacterController ()

@end

@implementation SearchContacterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = NorMalBackGroudColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.height = self.view.height - 108;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//    }];
//    [self.tableView addGestureRecognizer:tap];
}
- (void)setSearchArray:(NSArray *)searchArray
{
    _searchArray = searchArray;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.searchArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [ContactTableViewCell sharedContactTableViewCell:tableView];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.contactModel = self.searchArray[indexPath.section];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactersModel *model = self.searchArray[indexPath.section];
    if (self.ClickUserBlock) {
        _ClickUserBlock(model);
        [self dismissViewControllerAnimated:YES completion:^{
            self.searchArray = @[];
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *headView = [UIView new];
        headView.backgroundColor = RGBACOLOR(235, 235, 241, 1);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.width - 30, 30)];
        label.text = [NSString stringWithFormat:@"共有%ld个结果",self.searchArray.count];
        label.font = [UIFont boldSystemFontOfSize:16];
        [headView addSubview:label];
        return headView;
    }else{
        return NULL;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}



@end
