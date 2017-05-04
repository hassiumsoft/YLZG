//
//  FriendDetialController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/19.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "FriendDetialController.h"
#import "NoDequTableCell.h"
#import "NormalTableCell.h"
#import "NSString+StrCategory.h"
#import "ChatViewController.h"

#import "YLZGDataManager.h"
#import <MJExtension.h>
#import "ImageBrowser.h"
#import "NoDequTableCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface FriendDetialController ()<UITableViewDataSource,UITableViewDelegate>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSArray * nameArray;
/** 基本信息 */
@property (strong,nonatomic) UIView *headView;
/** 底部 */
@property (strong,nonatomic) UIView *footView;
/** 地区 */
@property (strong,nonatomic) UILabel *locationLabel;
/** 生日 */
@property (strong,nonatomic) UILabel *birthLabel;
/** 部门 */
@property (strong,nonatomic) UILabel *deptLabel;


@end

@implementation FriendDetialController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看详情";
    self.title = self.contactModel.realname.length >= 1 ? self.contactModel.realname : self.contactModel.nickname;
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.nameArray = @[@[@"基本信息"],@[@"设置备注"],@[@"地区",@"生日",@"部门"]];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = self.footView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.nameArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nameArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 基本信息
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.label removeFromSuperview];
        [cell.imageV removeFromSuperview];
        [cell.contentView addSubview:self.headView];
        return cell;
    }else if (indexPath.section == 1){
        // 备注
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell.label removeFromSuperview];
        [cell.imageV removeFromSuperview];
        cell.textLabel.text = self.nameArray[indexPath.section][indexPath.row];
        return cell;
    }else{
        // 其他信息

        if (indexPath.row == 0) {
            // 地区
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            [cell.label removeFromSuperview];
            [cell.imageV removeFromSuperview];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = self.nameArray[indexPath.section][indexPath.row];
            [cell.contentView addSubview:self.locationLabel];
            self.locationLabel.text = self.contactModel.location;
            return cell;
        }else if (indexPath.row == 1){
            // 生日
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            [cell.label removeFromSuperview];
            [cell.imageV removeFromSuperview];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = self.nameArray[indexPath.section][indexPath.row];
            [cell.contentView addSubview:self.birthLabel];
            self.birthLabel.text = self.contactModel.birth;
            return cell;
        }else {
            // 部门
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            [cell.label removeFromSuperview];
            [cell.imageV removeFromSuperview];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = self.nameArray[indexPath.section][indexPath.row];
            [cell.contentView addSubview:self.deptLabel];
            self.deptLabel.text = self.contactModel.dept;
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }else if (indexPath.section == 1){
        return 50;
    }else{
        return 50;
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
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {

        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.userInteractionEnabled = YES;
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.contactModel.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
        imageV.layer.masksToBounds = YES;
        imageV.userInteractionEnabled = YES;
        imageV.layer.cornerRadius = 4;
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [ImageBrowser showImage:imageV];
        }];
        [imageV addGestureRecognizer:tap];
        [_headView addSubview:imageV];
        
        // 昵称
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 15, 24, SCREEN_WIDTH - 80, 21)];
        nameLabel.text = self.contactModel.nickname.length >= 1 ? self.contactModel.nickname : self.contactModel.realname;
        nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [_headView addSubview:nameLabel];
        
        // 影楼ID
        UILabel *IDLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+15, CGRectGetMaxY(nameLabel.frame), SCREEN_WIDTH - 80, 21)];
        IDLabel.text = [NSString stringWithFormat:@"影楼ID：%@",self.contactModel.name];
        IDLabel.userInteractionEnabled = YES;
        IDLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        IDLabel.textColor = RGBACOLOR(87, 87, 87, 1);
        [_headView addSubview:IDLabel];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
            [pasteBoard setString:self.contactModel.name];
            [self showSuccessTips:@"已复制此ID"];
        }];
        [IDLabel addGestureRecognizer:longTap];
        
        
    }
    return _headView;
}

- (void)sendMessage
{
    if (self.isRootPush) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [YLNotificationCenter postNotificationName:HXRePushToChat object:@"1" userInfo:[self.contactModel mj_keyValues]];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)call
{
    NSString *number = self.contactModel.mobile;
    NSURL *phoheURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]];
    UIWebView *phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoheURL]];
    [self.view addSubview:phoneWebView];
}
- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180*CKproportion)];
        _footView.userInteractionEnabled = YES;
        _footView.backgroundColor = self.view.backgroundColor;
        
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        messageBtn.frame = CGRectMake(17, 20, SCREEN_WIDTH - 34, 40);
        messageBtn.layer.cornerRadius = 5;
        messageBtn.layer.masksToBounds = YES;
        messageBtn.backgroundColor = MainColor;
        [messageBtn setTitle:@"发送消息" forState:UIControlStateNormal];
        [messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [messageBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        messageBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        messageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_footView addSubview:messageBtn];
        
        
        UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneBtn.frame = CGRectMake(17, CGRectGetMaxY(messageBtn.frame) + 12, SCREEN_WIDTH - 34, 40);
        phoneBtn.layer.cornerRadius = 5;
        phoneBtn.layer.masksToBounds = YES;
        [phoneBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        phoneBtn.layer.masksToBounds = YES;
        [phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
        phoneBtn.layer.borderColor = NormalColor.CGColor;
        phoneBtn.layer.borderWidth = 1.f;
        [phoneBtn setTitleColor:MainColor forState:UIControlStateNormal];
        phoneBtn.backgroundColor = [UIColor whiteColor];
        [_footView addSubview:phoneBtn];
        
    }
    return _footView;
}
- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width  - 200, 10, 170, 30)];
        _locationLabel.textAlignment = NSTextAlignmentRight;
        _locationLabel.font = [UIFont systemFontOfSize:16];
        _locationLabel.textColor = RGBACOLOR(45, 45, 45, 1);
    }
    return _locationLabel;
}
- (UILabel *)birthLabel
{
    if (!_birthLabel) {
        _birthLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width  - 200, 10, 170, 30)];
        _birthLabel.textAlignment = NSTextAlignmentRight;
        _birthLabel.font = [UIFont systemFontOfSize:16];
        _birthLabel.textColor = RGBACOLOR(45, 45, 45, 1);
    }
    return _birthLabel;
}
- (UILabel *)deptLabel
{
    if (!_deptLabel) {
        _deptLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width  - 200, 10, 170, 30)];
        _deptLabel.textAlignment = NSTextAlignmentRight;
        _deptLabel.font = [UIFont systemFontOfSize:16];
        _deptLabel.textColor = RGBACOLOR(45, 45, 45, 1);
    }
    return _deptLabel;
}


@end
