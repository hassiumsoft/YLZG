//
//  SettingViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SettingViewController.h"
#import "NormalTableCell.h"
#import "ZCAccountTool.h"
#import <LCActionSheet.h>
#import <Masonry.h>
#import "ApplyViewController.h"
#import "PushNotificationViewController.h"
#import "ClearCacheTool.h"

@interface SettingViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
@property (copy,nonatomic) NSArray *array;
/** 自动登录开关 */
@property (strong,nonatomic) UISwitch *loginSwitch;
/** 信息排序 */
@property (strong,nonatomic) UISwitch *sortMethodSwitch;
/** 退群时删除会话 */
@property (strong,nonatomic) UISwitch *tuiQunSwitch;
///** 显示视频通话时间 */
//@property (strong,nonatomic) UISwitch *callTimeSwitch;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.array = [NSArray arrayWithObjects:@[@"自动登录",@"推送设置"],@[@"退群时删除会话",@"设置视频通话码率",@"消息根据服务器时间排序"],@[@"退出登录"], nil];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    [self refreshConfig];
}

- (void)refreshConfig
{
    [self.loginSwitch setOn:[[EMClient sharedClient].options isAutoLogin] animated:YES];
    [self.sortMethodSwitch setOn:[[EMClient sharedClient].options sortMessageByServerTime] animated:YES];
    
    [self.tableView reloadData];
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
        if (indexPath.row == 0) {
            // 自动登录
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell addSubview:self.loginSwitch];
            return cell;
        } else {
            // 推送设置
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;
        }
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            // 退群时删除会话
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell addSubview:self.tuiQunSwitch];
            return cell;
        } else if(indexPath.row == 1){
            
            // 设置视频通话码率
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            return cell;

        }else{
            // 消息根据服务器时间排序
            NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell addSubview:self.sortMethodSwitch];
            return cell;

        }
    }
    else{
        // 退出账号
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.backgroundColor = self.view.backgroundColor;
        UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        returnBtn.backgroundColor = WechatRedColor;
        [returnBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        ZCAccount *account = [ZCAccountTool account];
        NSString *message = [NSString stringWithFormat:@"退出账号(%@)",account.username];
        [returnBtn setTitle:message forState:UIControlStateNormal];
        returnBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        returnBtn.layer.cornerRadius = 3;
        [cell addSubview:returnBtn];
        [returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(cell.mas_centerX);
            make.centerY.equalTo(cell.mas_centerY);
            make.left.equalTo(@23);
            make.height.equalTo(@37);
        }];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            // 推送设置
            PushNotificationViewController *pushController = [[PushNotificationViewController alloc] init];
            [self.navigationController pushViewController:pushController animated:YES];
        }
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
           // 退群时删除会话
        } else if(indexPath.row == 1){
            // 设置视频通话码率
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"设置视频通话码率" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
           // UITextField *textField = [alert textFieldAtIndex:0];
//            EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
//            textField.text = [NSString stringWithFormat:@"%ld", options.videoKbps];

            [alert show];
            
        }else{
            // 消息根据服务器时间排序
            
        }
    }
}

#pragma mark - 退出登录
- (void)logoutAction
{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确定退出，换号登录？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            __weak SettingViewController *weakSelf = self;
            [self showHudMessage:@"退出登录"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = [[EMClient sharedClient] logout:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf hideHud:0];
                    if (error != nil) {
                        
                        [weakSelf showErrorTips:error.errorDescription];
                    }else{
                        [self clearSomeDataComplete:^{
                            [self.navigationController popViewControllerAnimated:YES];
                            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                        }];
                        
                    }
                });
            });
        }
    } otherButtonTitles:@"确定", nil];
    sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
    [sheet show];
    
}
#pragma mark - 清除一些垃圾数据、缓存
- (void)clearSomeDataComplete:(DeleteCompleteBlock)deleteBlock
{
    // 清除沙盒里的数据
    // ⚠️ 开发阶段并没有删除ZCAccount里的数据
    NSString *dicPath = [ClearCacheTool docPath];
    [ClearCacheTool clearSDWebImageCache:dicPath];
    
    NSUserDefaults *userDefault = USER_DEFAULT;
    [userDefault removeObjectForKey:@"userPhone"]; // 缓存手机号码的键
    [userDefault removeObjectForKey:@"city"]; // 地区缓存
    [userDefault removeObjectForKey:@"birthDay"]; // 生日
    
    deleteBlock();
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 28;
    } else {
        return 8;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
    foot.backgroundColor = self.view.backgroundColor;
    return foot;
}
- (UISwitch *)loginSwitch
{
    if (!_loginSwitch) {
        _loginSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 5, 40, 33)];
        [_loginSwitch addTarget:self action:@selector(autoLoginChanged:) forControlEvents:UIControlEventValueChanged];
        [_loginSwitch setOn:YES animated:YES];
        
    }
    return _loginSwitch;
}
- (void)autoLoginChanged:(UISwitch *)autoSwitch
{
    
    [[EMClient sharedClient].options setIsAutoLogin:autoSwitch.isOn];
}

- (UISwitch *)sortMethodSwitch
{
    if (!_sortMethodSwitch) {
        _sortMethodSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 5, 40, 33)];
        //[_sortMethodSwitch setOn:YES animated:YES];
//        _sortMethodSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:HXShowCallInfo] boolValue];
        [_sortMethodSwitch addTarget:self action:@selector(sortMethodChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _sortMethodSwitch;
}
- (UISwitch *)tuiQunSwitch
{
    if (!_tuiQunSwitch)
    {
        _tuiQunSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 5, 40, 33)];
        _tuiQunSwitch.on = [[EMClient sharedClient].options isDeleteMessagesWhenExitGroup];
        [_tuiQunSwitch addTarget:self action:@selector(delConversationChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _tuiQunSwitch;
}




- (void)sortMethodChanged:(UISwitch *)control
{
    [[EMClient sharedClient].options setSortMessageByServerTime:control.on];
}



- (void)delConversationChanged:(UISwitch *)control
{
    [[EMClient sharedClient].options setIsDeleteMessagesWhenExitGroup:control.on];
}




#pragma mark UIAlertView Delegate
//
////弹出提示的代理方法
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//#if DEMO_CALL == 1
//    if ([alertView cancelButtonIndex] != buttonIndex) {
//        //获取文本输入框
//        UITextField *nameTextField = [alertView textFieldAtIndex:0];
//        BOOL flag = YES;
//        if(nameTextField.text.length > 0) {
//            NSScanner* scan = [NSScanner scannerWithString:nameTextField.text];
//            int val;
//            if ([scan scanInt:&val] && [scan isAtEnd]) {
//                if ([nameTextField.text intValue] >= 150 && [nameTextField.text intValue] <= 1000) {
//                    EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
//                    options.videoKbps = [nameTextField.text intValue];
//                    [ChatDemoHelper updateCallOptions];
//                    flag = NO;
//                }
//            }
//        }
//        if (flag) {
//            [self showHint:NSLocalizedString(@"setting.setBitrateTips", @"Set Bitrate should be 150-1000")];
//        }
//    }
//#endif
//}


@end
