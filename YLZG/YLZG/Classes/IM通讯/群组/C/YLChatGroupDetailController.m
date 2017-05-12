//
//  YLChatGroupDetailController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "YLChatGroupDetailController.h"
#import <MJExtension.h>
#import "NormalTableCell.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import "ContactersModel.h"
#import "GroupMemberView.h"
#import "FriendDetialController.h"
#import "AllMembersController.h"
#import "UserInfoViewController.h"
#import "GroupNameViewController.h"
#import "NoDequTableCell.h"
#import <LCActionSheet.h>
#import "GroupMsgManager.h"
#import "YLZGDataManager.h"
#import <EMGroup.h>
#import "IviteMemberViewController.h"

@interface YLChatGroupDetailController ()<UITableViewDelegate,UITableViewDataSource>

/** 会话模型 */
@property (strong,nonatomic) EMConversation *conversation;

/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 头部 */
@property (strong,nonatomic) GroupMemberView *headView;
/** 数据源 */
@property (copy,nonatomic) NSArray *array;
/** 成员数组 */
@property (copy,nonatomic) NSMutableArray *memberArr;
/** 我是否为群主 */
@property (assign,nonatomic) BOOL isMyGroup;
/** 消息免打扰按钮 */
@property (strong,nonatomic) UISwitch *switchV;

/** 发消息按钮 */
@property (strong,nonatomic) UIButton *sendMsgBtn;
/** 退出群聊按钮 */
@property (strong,nonatomic) UIButton *returnGroupBtn;


@end

@implementation YLChatGroupDetailController


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
    self.title = @"群聊详情";
    ZCAccount *account = [ZCAccountTool account];
    if ([self.groupModel.owner isEqualToString:account.username]) {
        // 我是群主
        self.isMyGroup = YES;
    }else{
        // 我不是群主
        self.isMyGroup = NO;
    }
    
    [self getMembersData:account];
    [self setupSubViews];
    
    
}
- (void)setupSubViews
{
    if (self.isMyGroup) {
        self.array = @[@[@"查看全部成员"],@[@"消息免打扰",@"群名称",@"群简介",@"清空消息"],@[@"发消息/解散群聊"]];
    }else{
        self.array = @[@[@"查看全部成员"],@[@"消息免打扰",@"群名称",@"群简介",@"清空消息"],@[@"发消息/退出群聊"]];
    }
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    
    EMError *error;
    EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:self.groupModel.gid includeMembersList:NO error:&error];
    [self.switchV setOn:!group.isPushNotificationEnabled];
    [self.tableView reloadData];
}
- (void)settingMessage:(UISwitch *)switchV
{
    [[EMClient sharedClient].groupManager ignoreGroupPush:self.groupModel.gid ignore:switchV.on];
}

#pragma mark - 获取群组成员数据
- (void)getMembersData:(ZCAccount *)account
{
    
    NSString *url = [NSString stringWithFormat:GroupMember_URL,account.userID,self.groupModel.id];
    KGLog(@"url = %@",url);
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        int code = [[[responseObject objectForKey:@"code"]description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray *memberArr = [responseObject objectForKey:@"members"];
            self.memberArr = [ContactersModel mj_objectArrayWithKeyValuesArray:memberArr];
            self.headView.memberArr = self.memberArr;
            [self.headView reloadData];
            [self.tableView reloadData];
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
}

#pragma mark - 表格相关
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
        // 查看全部成员
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [cell.xian removeFromSuperview];
        cell.textLabel.text = self.array[indexPath.section][indexPath.row];
        return cell;
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            // 消息免打扰
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [cell.xian removeFromSuperview];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell addSubview:self.switchV];
            return cell;
        } else if(indexPath.row == 1){
            // 群名称设置
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.contentLabel.text = self.groupModel.gname;
            return cell;
        }else if (indexPath.row == 2){
            // 群简介
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.groupModel.dsp;
            return cell;
        }else{
            // 群人数
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else{
        // 群聊设置
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [cell.xian removeFromSuperview];
        [cell addSubview:self.sendMsgBtn];
        [cell addSubview:self.returnGroupBtn];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 查看全部成员
        AllMembersController *memebers = [AllMembersController new];
        memebers.memberArr = self.memberArr;
        memebers.groupModel = self.groupModel;
        __weak __block YLChatGroupDetailController *copy_self = self;
        memebers.DidSelectBlock = ^(NSIndexPath *indexPath){
            ContactersModel *model = copy_self.memberArr[indexPath.item];
            ZCAccount *account = [ZCAccountTool account];
            if ([model.name isEqualToString:account.username]) {
                UserInfoViewController *userInfo = [UserInfoViewController new];
                [copy_self.navigationController pushViewController:userInfo animated:YES];
            }else{
                FriendDetialController *friend = [FriendDetialController new];
                friend.contactModel = model;
                friend.isRootPush = YES;
                [copy_self.navigationController pushViewController:friend animated:YES];
            }
        };
        [self.navigationController pushViewController:memebers animated:YES];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            // 消息免打扰
        } else if(indexPath.row == 1){
            // 群名称设置  暂不开放
            GroupNameViewController *changeName = [GroupNameViewController new];
            changeName.nameType = ChangeNameType;
            changeName.YLGroupModelBlock = ^(YLGroup *groupModel){
                self.groupModel = groupModel;
                [self.tableView reloadData];
            };
            changeName.groupModel = self.groupModel;
            [self.navigationController pushViewController:changeName animated:YES];
        }else if (indexPath.row == 2){
            // 群简介设置
            GroupNameViewController *changeName = [GroupNameViewController new];
            changeName.nameType = ChangeDspTye;
            changeName.YLGroupModelBlock = ^(YLGroup *groupModel){
                self.groupModel = groupModel;
                [self.tableView reloadData];
            };
            changeName.groupModel = self.groupModel;
            [self.navigationController pushViewController:changeName animated:YES];
        }else{
            // 清除聊天记录
            if (!self.conversation) {
                return;
            }
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 120;
    } else {
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]init];
    if (section == 2) {
        foot.backgroundColor = [UIColor clearColor];
    }else{
        foot.backgroundColor = self.view.backgroundColor;
    }
    return foot;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_GroupModelBlock) {
        _GroupModelBlock(self.groupModel);
    }
}
#pragma mark - 操作
- (void)sendMessageAction
{
    if (self.isRootPush) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        YLGroup *model = self.groupModel;
        [YLNotificationCenter postNotificationName:HXRePushToChat object:@"2" userInfo:[model mj_keyValues]];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 退出群聊
- (void)ReturnGroupAction
{
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确定退出群聊？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            // 退出群聊
            ZCAccount *account = [ZCAccountTool account];
            NSString *url = [NSString stringWithFormat:@"http://192.168.0.158/index.php/home/easemob/quit_group?uid=%@&gid=%@&id=%@",account.userID,self.groupModel.gid,self.groupModel.id];
            
            [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                
                int code = [[[responseObject objectForKey:@"code"] description] intValue];
                NSString *message = [[responseObject objectForKey:@"message"] description];
                if (code == 1) {
                    
                    // 清除一些缓存
                    
                    [[YLZGDataManager sharedManager] updataGroupInfoWithBlock:^{
                        
                        [YLNotificationCenter postNotificationName:HXRemoveAllMessages object:self.groupModel.gid];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    
                }else{
                    [self sendErrorWarning:message];
                }
                
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                [self sendErrorWarning:error.localizedDescription];
            }];
        }
    } otherButtonTitles:@"确定退出", nil];
    sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
    [sheet show];
    
}
- (void)GiveupGroup
{
    // 解散群聊
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确定解散该群聊？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            // 解散群聊
            ZCAccount *account = [ZCAccountTool account];
            NSString *url = [NSString stringWithFormat:@"http://192.168.0.158/index.php/home/easemob/dismiss_group?uid=%@&sid=%@&gid=%@&id=%@",account.userID,self.groupModel.sid,self.groupModel.gid,self.groupModel.id];
            
            [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                
                int code = [[[responseObject objectForKey:@"code"] description] intValue];
                NSString *message = [[responseObject objectForKey:@"message"] description];
                
                if (code == 1) {
                    
                    // 清除一些缓存
                    
                    [[YLZGDataManager sharedManager] updataGroupInfoWithBlock:^{
                        [MBProgressHUD hideHUD];
                        [YLNotificationCenter postNotificationName:HXRemoveAllMessages object:self.groupModel.gid];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    
                }else{
                    [self sendErrorWarning:message];
                }
                
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                [self sendErrorWarning:error.localizedDescription];
            }];
        }
    } otherButtonTitles:@"确定解散", nil];
    sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
    [sheet show];
}
#pragma mark - 踢出某个成员
- (void)deleteOneMembers
{
    IviteMemberViewController *ivite = [IviteMemberViewController new];
    ivite.AddMembersBlock = ^(NSArray *memberArr){
        [self.memberArr removeAllObjects];
        ZCAccount *account = [ZCAccountTool account];
        [self getMembersData:account];
        KGLog(@"newMemberArr = %@",memberArr);
    };
    ivite.groupArr = self.memberArr;
    ivite.type = DeleteMemberType;
    ivite.title = @"踢除出人";
    ivite.groupModel = self.groupModel;
    [self.navigationController pushViewController:ivite animated:YES];
}
#pragma mark - 邀请成员
- (void)ivitMembers
{
    IviteMemberViewController *ivite = [IviteMemberViewController new];
    ivite.groupArr = self.memberArr;
    ivite.type = AddMemberType;
    ivite.title = @"邀请入群";
    ivite.groupModel = self.groupModel;
    [self.navigationController pushViewController:ivite animated:YES];
}
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}
- (GroupMemberView *)headView
{
    if (!_headView) {
        CGFloat cellW = (SCREEN_WIDTH - 3 * 2)/4;
        _headView = [[GroupMemberView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2 * cellW + 2)]; // 186.5
        _headView.memberArr = self.memberArr;
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.userInteractionEnabled = YES;
        __weak __block YLChatGroupDetailController *copy_self = self;
        _headView.DidSelectBlock = ^(NSIndexPath *indexPath){
            if (indexPath.item <= self.memberArr.count - 1) {
                ContactersModel *model = copy_self.memberArr[indexPath.item];
                ZCAccount *account = [ZCAccountTool account];
                if ([model.name isEqualToString:account.username]) {
                    UserInfoViewController *userInfo = [UserInfoViewController new];
                    [copy_self.navigationController pushViewController:userInfo animated:YES];
                }else{
                    FriendDetialController *friend = [FriendDetialController new];
                    friend.contactModel = model;
                    friend.isRootPush = YES;
                    [copy_self.navigationController pushViewController:friend animated:YES];
                }
            }else if(indexPath.item <= self.memberArr.count){
                // 邀请成员
                if (![copy_self.groupModel.allowinvites boolValue]) {
                    [copy_self showErrorTips:@"此群不允许邀请成员邀请"];
                    return ;
                }
                [copy_self ivitMembers];
            }else{
                // 剔除成员
                if (!copy_self.isMyGroup) {
                    [copy_self showErrorTips:@"您不是群主"];
                    return;
                }
                [copy_self deleteOneMembers];
            }
            
        };
    }
    return _headView;
}
- (UISwitch *)switchV
{
    if (!_switchV) {
        _switchV = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 10, 55, 40)];
        _switchV.onTintColor = MainColor;
        [_switchV addTarget:self action:@selector(settingMessage:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchV;
}
- (UIButton *)sendMsgBtn
{
    if (!_sendMsgBtn) {
        _sendMsgBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 20, SCREEN_WIDTH - 50, 40)];
        _sendMsgBtn.layer.cornerRadius = 5;
        _sendMsgBtn.backgroundColor = NormalColor;
        [_sendMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendMsgBtn setTitle:@"发消息" forState:UIControlStateNormal];
        [_sendMsgBtn addTarget:self action:@selector(sendMessageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendMsgBtn;
}
- (UIButton *)returnGroupBtn
{
    if (!_returnGroupBtn) {
        _returnGroupBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 20 + 40 + 10, SCREEN_WIDTH - 50, 40)];
        _returnGroupBtn.layer.cornerRadius = 5;
        _returnGroupBtn.backgroundColor = WechatRedColor;
        [_returnGroupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (!self.isMyGroup) {
            [_returnGroupBtn setTitle:@"退出群聊" forState:UIControlStateNormal];
            [_returnGroupBtn addTarget:self action:@selector(ReturnGroupAction) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_returnGroupBtn setTitle:@"解散群聊" forState:UIControlStateNormal];
            [_returnGroupBtn addTarget:self action:@selector(GiveupGroup) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _returnGroupBtn;
}


@end
