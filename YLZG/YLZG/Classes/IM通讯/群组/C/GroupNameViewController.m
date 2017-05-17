//
//  GroupNameViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "GroupNameViewController.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import "GroupMsgManager.h"
#import "YLZGDataManager.h"
#import <Masonry.h>

@interface GroupNameViewController ()<UITextFieldDelegate>

@property (strong,nonatomic) UITextField *textField;

@end

@implementation GroupNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.nameType == CreateGroupType) {
        self.title = @"群聊名称";
    }else if(self.nameType == ChangeNameType){
        self.title = self.groupModel.gname;
    }else{
        self.title = @"修改简介";
    }
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:24];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@24);
        make.top.equalTo(self.view.mas_top).offset(100);
    }];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(40, 200*CKproportion, SCREEN_WIDTH - 80, 45)];
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(12, 0, 0, 0)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self.view addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.mas_left).offset(-10);
        make.right.equalTo(self.textField.mas_right).offset(10);
        make.top.equalTo(self.textField.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = MainColor;
    [commitBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    if (self.nameType == CreateGroupType) {
        [commitBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }else if(self.nameType == ChangeNameType){
        // 修改群名称
        [commitBtn addTarget:self action:@selector(changeGroupName:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        // 修改简介
        [commitBtn addTarget:self action:@selector(changeGroupDsp) forControlEvents:UIControlEventTouchUpInside];
    }
    commitBtn.layer.cornerRadius = 4;
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xian.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.height.equalTo(@40);
    }];
    
    
    if (self.nameType == CreateGroupType) {
        // 建群
        label.text = @"符合群聊内容的名称";
        self.textField.placeholder = @"如：影楼内部交流";
    } else if(self.nameType == ChangeNameType){
        // 改名
        label.text = @"修改群聊的名称";
        self.textField.placeholder = self.groupModel.gname;
    }else{
        // 改昵称
        label.text = @"修改群聊的简介";
        self.textField.placeholder = self.groupModel.dsp;
    }
}
#pragma mark - 修改群消息
- (void)changeGroupName:(UIButton *)sender
{
    
    if (self.textField.text.length < 1) {
        [self showErrorTips:@"请输入内容"];
        return;
    }
    
    [self.view endEditing:YES];
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/edit_group_info?uid=%@&id=%@&gid=%@&name=%@",account.userID,self.groupModel.id,self.groupModel.gid,self.textField.text];
    
    [MBProgressHUD showMessage:@"请稍后"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            
            self.title = self.textField.text;
            
            [[YLZGDataManager sharedManager] updataGroupInfoWithBlock:^{
                [MBProgressHUD hideHUD];
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.groupModel.gname = self.textField.text;
                    // 修改缓存
                    if (_YLGroupModelBlock) {
                        _YLGroupModelBlock(self.groupModel);
                    }
                    [YLNotificationCenter postNotificationName:HXUpdataGroupInfo object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }];
                
                [alertC addAction:action1];
                [self presentViewController:alertC animated:YES completion:^{
                    
                }];
            }];
            
        }else{
            [MBProgressHUD hideHUD];
            [self showErrorTips:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        // sendErrorWarning
        [self sendErrorWarning:error.localizedDescription];
    }];
}
#pragma mark - 修改简介
- (void)changeGroupDsp
{
    if (self.textField.text.length < 1) {
        [self showErrorTips:@"请输入内容"];
        return;
    }
    [self.view endEditing:YES];
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/edit_group_info?uid=%@&id=%@&gid=%@&dsp=%@",account.userID,self.groupModel.id,self.groupModel.gid,self.textField.text];
    
    [MBProgressHUD showMessage:@"请稍后"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            
            
            
            [[YLZGDataManager sharedManager] updataGroupInfoWithBlock:^{
                [MBProgressHUD hideHUD];
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.groupModel.dsp = self.textField.text;
                    // 修改缓存
                    if (_YLGroupModelBlock) {
                        _YLGroupModelBlock(self.groupModel);
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }];
                
                [alertC addAction:action1];
                [self presentViewController:alertC animated:YES completion:^{
                    
                }];
            }];
            
        }else{
            [MBProgressHUD hideHUD];
            [self showErrorTips:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        // sendErrorWarning
        [self sendErrorWarning:error.localizedDescription];
    }];
}
#pragma mark - 建群
- (void)sendAction:(UIButton *)sender
{
    [self.view endEditing:YES];

    if (_NameBlock) {
        _NameBlock(self.textField.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
