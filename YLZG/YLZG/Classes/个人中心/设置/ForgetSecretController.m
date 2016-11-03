//
//  ForgetSecretController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/1.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "ForgetSecretController.h"
#import "HTTPManager.h"
#import "NSString+StrCategory.h"
#import "ZCAccountTool.h"
#import "UserInfoManager.h"
#import <Masonry.h>

@interface ForgetSecretController ()

@property (strong,nonatomic) UITextField *oldPass;

@property (strong,nonatomic) UITextField *xinPass1;

@property (strong,nonatomic) UITextField *xinPass2;

@property (strong,nonatomic) UIButton *button;

@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;


@end

@implementation ForgetSecretController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self setupSubViews];
}
- (void)setupSubViews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.oldPass];
    [self.view addSubview:self.xinPass1];
    [self.view addSubview:self.xinPass2];
    [self.view addSubview:self.button];
}
- (UITextField *)oldPass
{
    if (!_oldPass) {
        _oldPass = [[UITextField alloc]initWithFrame:CGRectMake(17, 81 - 64, SCREEN_WIDTH - 34, 38)];
        _oldPass.backgroundColor = [UIColor whiteColor];
        _oldPass.layer.cornerRadius = 3;
        [_oldPass becomeFirstResponder];
        _oldPass.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 0)];
        _oldPass.leftViewMode = UITextFieldViewModeAlways;
        _oldPass.placeholder = @"旧密码";
        _oldPass.attributedPlaceholder = [[NSAttributedString alloc]initWithString:_oldPass.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        _oldPass.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _oldPass;
}
- (UITextField *)xinPass1
{
    if (!_xinPass1) {
        _xinPass1 = [[UITextField alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(self.oldPass.frame) + 10, SCREEN_WIDTH - 34, 38)];
        _xinPass1.backgroundColor = [UIColor whiteColor];
        _xinPass1.layer.cornerRadius = 3;
        _xinPass1.placeholder = @"新密码";
        _xinPass1.attributedPlaceholder = [[NSAttributedString alloc]initWithString:_xinPass1.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        _xinPass1.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 0)];
        _xinPass1.leftViewMode = UITextFieldViewModeAlways;
        _xinPass1.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _xinPass1;
}
- (UITextField *)xinPass2
{
    if (!_xinPass2) {
        _xinPass2 = [[UITextField alloc]initWithFrame:CGRectMake(17, CGRectGetMaxY(self.xinPass1.frame) + 10, SCREEN_WIDTH - 34, 38)];
        _xinPass2.backgroundColor = [UIColor whiteColor];
        _xinPass2.layer.cornerRadius = 3;
        _xinPass2.placeholder = @"确认新密码";
        _xinPass2.attributedPlaceholder = [[NSAttributedString alloc]initWithString:_xinPass2.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        _xinPass2.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 0)];
        _xinPass2.leftViewMode = UITextFieldViewModeAlways;
        _xinPass2.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _xinPass2;
}
- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setFrame:CGRectMake(17, CGRectGetMaxY(self.xinPass2.frame) + 20, SCREEN_WIDTH - 34, 38)];
        _button.backgroundColor = MainColor;
        [_button setTitle:@"确定修改" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _button.layer.cornerRadius = 3;
        
    }
    return _button;
}
- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.button addSubview:_indicatorV];
        [_indicatorV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.button.mas_centerX);
            make.centerY.equalTo(self.button.mas_centerY);
            make.width.and.height.equalTo(@33);
        }];
    }
    return _indicatorV;
}
- (void)buttonClick:(UIButton *)sender
{
    UserInfoModel *model = [UserInfoManager getUserInfo];
    if (![self.oldPass.text isEqualToString:model.password]) {
        [self sendErrorWarning:@"旧密码不正确"];
        return;
    }
    if (self.xinPass1.text.length < 1 || self.xinPass2.text.length < 1) {
        [self sendErrorWarning:@"请输入新密码"];
        return;
    }
    if (![self.xinPass1.text isEqualToString:self.xinPass2.text]) {
        [self sendErrorWarning:@"两次密码不一致"];
        return;
    }
    
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self.indicatorV startAnimating];
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:UploadPassWordURL,self.oldPass.text,self.xinPass2.text,account.userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        [self.indicatorV stopAnimating];
        [sender setTitle:@"确认修改" forState:UIControlStateNormal];
        if (code == 1) {
            BOOL result = [UserInfoManager updataUserInfoWithKey:@"password" Value:self.xinPass2.text];
            if (result) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                [alertC addAction:action1];
                [self presentViewController:alertC animated:YES completion:^{
                    
                }];
            }
            
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.indicatorV stopAnimating];
        [sender setTitle:@"确认修改" forState:UIControlStateNormal];
        [self showErrorTips:error.localizedDescription];
    }];
    
    
    
}

@end
