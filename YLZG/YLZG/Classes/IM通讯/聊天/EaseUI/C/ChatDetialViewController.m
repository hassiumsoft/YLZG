//
//  ChatDetialViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "ChatDetialViewController.h"
#import "NormalTableCell.h"
#import "FriendDetialController.h"
#import <UIImageView+WebCache.h>
#import "CreateGroupViewController.h"
#import "HomeNavigationController.h"
#import "SearchMessageViewController.h"
#import <LCActionSheet.h>

@interface ChatDetialViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 消息免打扰 */
@property (strong,nonatomic) UISwitch *switchView;

/** 会话 */
@property (strong,nonatomic) EMConversation *conversation;

@end

@implementation ChatDetialViewController

- (instancetype)initWithConversation:(EMConversation *)conversation
{
    self = [super init];
    if (self) {
        self.conversation = conversation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单聊详情";
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.array = @[@[@"消息免打扰"],@[@"查找聊天内容"],@[@"清除聊天记录"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(2, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    headView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headView;
    
    // 头像
    UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 18, 50, 50)];
    [headImgView sd_setImageWithURL:[NSURL URLWithString:self.contactModel.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    headImgView.layer.masksToBounds = YES;
    headImgView.userInteractionEnabled = YES;
    headImgView.layer.cornerRadius = 4;
    headImgView.contentMode = UIViewContentModeScaleAspectFill;
    [headView addSubview:headImgView];
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        FriendDetialController *friend = [FriendDetialController new];
        friend.contactModel = self.contactModel;
        friend.isRootPush = YES;
        [self.navigationController pushViewController:friend animated:YES];
    }];
    [headImgView addGestureRecognizer:headTap];
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(headImgView.frame) + 3, 50, 21)];
    nameLabel.text = self.contactModel.nickname.length > 0 ? self.contactModel.nickname : self.contactModel.realname;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:nameLabel];
    
    // 右边的加号
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"add_members"] forState:UIControlStateNormal];
    addButton.frame = CGRectMake(CGRectGetMaxX(headImgView.frame) + 15, headImgView.y, headImgView.width, headImgView.height);
    [addButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        CreateGroupViewController *group = [[CreateGroupViewController alloc]initWithAnother:self.contactModel];
        HomeNavigationController *nav = [[HomeNavigationController alloc]initWithRootViewController:group];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }];
    [headView addSubview:addButton];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 免打扰
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        [cell.label removeFromSuperview];
        [cell.imageV removeFromSuperview];
        [cell.xian removeFromSuperview];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.contentView addSubview:self.switchView];
        return cell;
    }else if (indexPath.section == 1){
        // 查找聊天消息
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        [cell.label removeFromSuperview];
        [cell.imageV removeFromSuperview];
        [cell.xian removeFromSuperview];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        return cell;
    }else {
        // 清除聊天记录
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        [cell.label removeFromSuperview];
        [cell.imageV removeFromSuperview];
        [cell.xian removeFromSuperview];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 消息免打扰
    
    } else if(indexPath.section == 1){
        // 查找聊天内容
        SearchMessageViewController *searchMessage = [[SearchMessageViewController alloc]initWithConversation:self.conversation];
        [self.navigationController pushViewController:searchMessage animated:YES];
    }else{
        // 清除聊天记录
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确定清空消息？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                EMError *error;
                [self.conversation deleteAllMessages:&error];
                if (error) {
                    [MBProgressHUD showError:error.errorDescription];
                }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            
        } otherButtonTitles:@"清空", nil];
        sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
        [sheet show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = [UIColor clearColor];
    return foot;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else{
        return 0.1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head = [UIView new];
    head.backgroundColor = [UIColor clearColor];
    return head;
}

#pragma mark - 懒加载
- (UISwitch *)switchView
{
    if (!_switchView) {
        _switchView = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.width - 60, 5, 40, 40)];
        _switchView.onTintColor = MainColor;
        _switchView.on = NO;
    }
    return _switchView;
}

@end
