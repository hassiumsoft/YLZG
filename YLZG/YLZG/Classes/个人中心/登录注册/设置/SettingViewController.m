//
//  SettingViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SettingViewController.h"
#import "ForgetSecretController.h"
#import "PushNotificationViewController.h"
#import <LCActionSheet.h>
#import <Masonry.h>
#import "ClearCacheTool.h"
#import "UserInfoManager.h"
#import "GroupListManager.h"
#import "StudioContactManager.h"
#import "HuanxinContactManager.h"
#import <SDImageCache.h>
#import "YLZGDataManager.h"
#import "NoDequTableCell.h"

@interface SettingViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;
@property (copy,nonatomic) NSArray *array;

/** 退出登录 */
@property (strong,nonatomic) UIView *returnView;
/** 自动登录按钮 */
@property (strong,nonatomic) UISwitch *loginSwitch;
/** 自动同意好友申请 */
@property (strong,nonatomic) UISwitch *addfriSwitch;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setupSubViews];
}
#pragma mark - 绘制UI
- (void)setupSubViews
{
    self.array = [NSArray arrayWithObjects:@[@"自动登录",@"修改密码"],@[@"推送设置",@"一键更新缓存",@"评分支持影楼掌柜",@"自动同意好友申请"], nil];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.returnView];
    
    [self refreshConfig];
}
- (void)refreshConfig
{
    [self.loginSwitch setOn:[[EMClient sharedClient].options isAutoLogin] animated:YES];
    [self.addfriSwitch setOn:[[EMClient sharedClient].options isAutoAcceptFriendInvitation] animated:YES];
    
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
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            [cell.contentLabel removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:self.loginSwitch];
            
            return cell;
        } else {
            // 修改密码
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            [cell.contentLabel removeFromSuperview];
            [cell setAccessoryType:UITableViewCellAccessoryDetailButton];

            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            
            return cell;
        }
    } else{
        if (indexPath.row == 0) {
            // 推送设置
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            [cell.contentLabel removeFromSuperview];
            [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            
            return cell;
        }else if(indexPath.row == 1){
            // 清理缓存
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            [cell.contentLabel removeFromSuperview];
            [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            
            return cell;
        }else if(indexPath.row == 2){
            // 评分支持影楼掌柜
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            [cell.contentLabel removeFromSuperview];
            [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            
            return cell;
        }else{
            // 自动同意好友请求
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            [cell.contentLabel removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.array[indexPath.section][indexPath.row];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:self.addfriSwitch];
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            // 修改密码
            ForgetSecretController *pass = [ForgetSecretController new];
            [self.navigationController pushViewController:pass animated:YES];
        }
    } else {
        if (indexPath.row == 0) {
            // 推送设置
            PushNotificationViewController *push = [PushNotificationViewController new];
            [self.navigationController pushViewController:push animated:YES];
        } else if(indexPath.row == 1){



            // 清理缓存
            NSString *dicPath = [ClearCacheTool docPath];
            [self clearSDWebImageCache:dicPath DeleteBlock:^{
                [self showSuccessTips:@"更新成功"];
            }];
        }else if (indexPath.row == 2){


            // 去评分
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ying-lou-zhang-gui/id1135389493?mt=8"]];
        }
    }
}
- (void)clearSDWebImageCache:(NSString *)path DeleteBlock:(DeleteCompleteBlock)deleBlock
{
    
    [self showHudMessage:@"~~~"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            if ([fileName isEqualToString:@"studio_contacts.sqlite"]
                || [fileName isEqualToString:@"huanxin_contacts.sqlite"]
                || [fileName isEqualToString:@"t_groups.sqlite"]) {
                
                [HuanxinContactManager deleteAllInfo];
                [StudioContactManager deleteAllInfo];
                [GroupListManager deleteAllGroupInfo];
            }
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
    [YLNotificationCenter postNotificationName:HXUpdataContacts object:nil];
    [[YLZGDataManager sharedManager] saveGroupInfoWithBlock:^{
        [self hideHud:0];
        deleBlock();
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHud:0];
    });
    
}
#pragma mark - 退出登录
- (void)logoutAction
{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"前后账号若一致，则不会删除您之前的聊天记录\r并且更新其他缓存数据。" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
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
                        
                        CATransition *animation = [CATransition animation];
                        animation.duration = 0.8;
                        animation.timingFunction = UIViewAnimationCurveEaseInOut;
                        animation.type = kCATransitionFade;
                        animation.subtype = kCATransitionFromBottom;
                        [self.view.window.layer addAnimation:animation forKey:nil];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        [YLNotificationCenter postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                        
                    }
                });
            });
        }
    } otherButtonTitles:@"确定退出", nil];
    sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
    [sheet show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc]initWithFrame:CGRectZero];
    foot.backgroundColor = self.view.backgroundColor;
    return foot;
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}
- (UIView *)returnView
{
    if (!_returnView) {
        _returnView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), SCREEN_WIDTH, 50)];
        _returnView.backgroundColor = [UIColor whiteColor];
        _returnView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [self logoutAction];
        }];
        [_returnView addGestureRecognizer:tap];
        
        UIImageView *returnImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"set_return"]];
        returnImgV.frame = CGRectMake(SCREEN_WIDTH/2 - 32, 12, 25, 25);
        [_returnView addSubview:returnImgV];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnImgV.frame) + 3, 12, 80, 25)];
        label.text = @"退出登录";
        label.textColor = RGBACOLOR(213, 33, 25, 1);
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout];
        [_returnView addSubview:label];
    }
    return _returnView;
}

- (UISwitch *)loginSwitch
{
    if (!_loginSwitch) {
        _loginSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 8, 40, 36)];
        _loginSwitch.onTintColor = MainColor;
        [_loginSwitch addTarget:self action:@selector(autoLoginChanged:) forControlEvents:UIControlEventValueChanged];
        [_loginSwitch setOn:YES animated:YES];
    }
    return _loginSwitch;
}
- (UISwitch *)addfriSwitch
{
    if (!_addfriSwitch) {
        _addfriSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 8, 40, 36)];
        _addfriSwitch.onTintColor = MainColor;
        [_addfriSwitch addTarget:self action:@selector(sortMethodChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _addfriSwitch;
}
- (void)autoLoginChanged:(UISwitch *)loginSwitch
{
    
    [[EMClient sharedClient].options setIsAutoLogin:loginSwitch.isOn];
}
- (void)sortMethodChanged:(UISwitch *)addfriSwitch
{
    // isAutoAcceptFriendInvitation
    [[EMClient sharedClient].options setIsAutoAcceptFriendInvitation:addfriSwitch.isOn];
}
@end
