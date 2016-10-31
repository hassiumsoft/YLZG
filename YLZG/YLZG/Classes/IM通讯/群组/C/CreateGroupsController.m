//
//  CreateGroupsController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/19.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CreateGroupsController.h"
#import "HTTPManager.h"
#import <LCActionSheet.h>
#import "NoDequTableCell.h"
#import "ZCAccountTool.h"
#import "GroupNameViewController.h"
#import "IvitGroupMembersController.h"


static CGFloat CellHeight = 50.f;
static NSString *TextPlace = @"一句话描述您的群聊";

@interface CreateGroupsController ()<UITableViewDataSource,UITableViewDelegate,LCActionSheetDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *titleArray;
/** 人数上限 */
@property (copy,nonatomic) NSString *maxusers;
/** 邀请的成员数组 */
@property (copy,nonatomic) NSArray *memberArr;
/** 群聊名称 */
@property (copy,nonatomic) NSString *groupName;
/** 是否允许邀请 */
@property (strong,nonatomic) UISwitch *switchV;
/** 群聊描述 */
@property (strong,nonatomic) UITextField *textField;
/** 按钮 */
@property (strong,nonatomic) UIButton *button;

@end

@implementation CreateGroupsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建群聊";
    self.titleArray = @[@[@"群聊名称"],@[@"邀请成员",@"设置人数上限",@"是否允许成员邀请他人"],@[@"群聊描述"],@[@"创建群聊"]];
    [self setupSubViews];
}
#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 创建群聊
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
        cell.contentLabel.text = self.groupName;
        return cell;
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            // 邀请成员
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
            if (self.memberArr.count > 0) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%ld个成员",(unsigned long)self.memberArr.count];
            }
            return cell;
        }else if (indexPath.row == 1){
            // 设置人数上限
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
            cell.contentLabel.text = self.maxusers;
            return cell;
        }else {
            // 是否允许成员邀请他人
            NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell addSubview:self.switchV];
            return cell;
        }
    } else if(indexPath.section == 2){
        // 群聊描述
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell addSubview:self.textField];
        return cell;
    }else{
        // 创建群聊按钮
        NoDequTableCell *cell = [NoDequTableCell sharedNoDequTableCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.backgroundColor = self.view.backgroundColor;
        [cell addSubview:self.button];
        [self.button setTitle:self.titleArray[indexPath.section][indexPath.row] forState:UIControlStateNormal];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        // 群聊名称
        GroupNameViewController *name = [GroupNameViewController new];
        name.nameType = CreateGroupType;
        name.NameBlock = ^(NSString *name){
            self.groupName = name;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:name animated:YES];
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            // 邀请成员
            IvitGroupMembersController *memes = [IvitGroupMembersController new];
            memes.MemebersBlock = ^(NSArray *members){
                self.memberArr = members;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:memes animated:YES];
        } else if(indexPath.row == 1){
            // 设置人数上限
            NSArray *maxArr = @[@"50人",@"100人",@"200人"];
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"设置群聊人数上限" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    return ;
                }
                self.maxusers = maxArr[buttonIndex - 1];
                [self.tableView reloadData];
            } otherButtonTitles:@"50人",@"100人",@"200人", nil];
            [sheet show];
        }else{
            // 是否允许邀请他人
            
        }
    }else if (indexPath.section == 2){
        // 群聊描述
    }else{
        // 创建群聊
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CellHeight;
    } else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            return CellHeight;
        } else if(indexPath.row == 1){
            return CellHeight;
        }else{
            return CellHeight;
        }
    }else if (indexPath.section == 2){
        return 55;
    }else{
        return CellHeight * 3 * CKproportion;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [UIView new];
    foot.backgroundColor = self.view.backgroundColor;
    
    return foot;
}

- (void)setupSubViews
{
//    http://zsylou.wxwkf.com/index.php/home/easemob/create_group?
//    uid=144
//    &name=群组名称
//    &dsp=群组描述
//    &public=0
//    &maxusers=200
//    &allowinvites=1
//    &members=[{"name":"aermei_dapeng","sid":"9","uid":"147"},{"name":"aermei_lele","sid":"9","uid":"326"}]
    
    [self.view addSubview:self.tableView];
    
}
#pragma mark - 创建群组
- (void)createGroup
{
    if (self.groupName.length < 1) {
        [self showErrorTips:@"请完善群组名称"];
        return;
    }
    if (self.memberArr.count < 1) {
        [self showErrorTips:@"请选择初始群成员"];
        return;
    }
    if (self.maxusers.length < 2) {
        [self showErrorTips:@"请选择群人数上限"];
        return;
    }
    if (self.textField.text.length < 1) {
        [self showErrorTips:@"请给您的群添加描述"];
        return;
    }
    NSString *maxMembers;
    if (self.maxusers.length == 3) {
        maxMembers = [self.maxusers substringWithRange:NSMakeRange(0, 2)];
    }else{
        maxMembers = [self.maxusers substringWithRange:NSMakeRange(0, 3)];
    }
    ZCAccount *account = [ZCAccountTool account];
    NSString *membersJson = [self toJsonStr:self.memberArr];
    NSString *url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/create_group?uid=%@&name=%@&dsp=%@&public=0&maxusers=%@&allowinvites=%d&members=%@",account.userID,self.groupName,self.textField.text,maxMembers,self.switchV.on,membersJson];
    KGLog(@"url = %@",url);
    [self showHudMessage:@"请稍后"];
    self.button.enabled = NO;
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        KGLog(@"responseObject = %@",responseObject);
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self hideHud:0];
        self.button.enabled = YES;
        if (code == 1) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (_ReloadBlock) {
                    _ReloadBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertC addAction:action1];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        self.button.enabled = YES;
        [self sendErrorWarning:error.localizedDescription];
    }];
}
#pragma mark - 懒加载
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(95, 5, SCREEN_WIDTH - 95 - 15, 45)];
        _textField.placeholder = TextPlace;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont systemFontOfSize:15];
    }
    return _textField;
}
- (UISwitch *)switchV
{
    if (!_switchV) {
        _switchV = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 10, 55, 40)];
        [_switchV setOn:YES animated:YES];
    }
    return _switchV;
}
- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = MainColor;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(createGroup) forControlEvents:UIControlEventTouchUpInside];
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 6;
        [_button setFrame:CGRectMake(20, 50, SCREEN_WIDTH - 40, 38)];
    }
    return _button;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        
    }
    return _tableView;
}

/**
接口名称：创建群组
功能：创建聊天群组
示例地址：http://zsylou.wxwkf.com/index.php/home/easemob/create_group?uid=144&name=群组名称&dsp=群组描述&public=0&maxusers=200&allowinvites=1&members=[{"name":"aermei_dapeng","sid":"9","uid":"147"},{"name":"aermei_lele","sid":"9","uid":"326"}]
必选参数：
uid   ——————> 用户UID
name    ————> 用户UID
可选参数：
members  ——————> 成员名单 json格式
包含： name  环信用户名
sid      店铺ID
uid      用户UID
public ————————> 公开群  1是 0否  ，默认是否【私有群】
maxusers  ——————> 最多成员数， 默认200 ，最高2000
allowinvites  —————> 允许组员邀请他人 1是 0否，默认允许；公开群默认不允许
返回值：
code => 1 成功
*/

@end
