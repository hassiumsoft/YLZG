//
//  OrderPhoneController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "OrderPhoneController.h"
#import "NSString+StrCategory.h"
#import <Masonry.h>

@interface OrderPhoneController ()

{
    UIButton *commitBtn;
}

@property (strong,nonatomic) UITextField *textField;

@end

@implementation OrderPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户电话";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];

}

- (void)createUI {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = @"请填写手机号码";
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
    [self.textField becomeFirstResponder];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = @"如：13855665566";
    [self.view addSubview:self.textField];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self.view addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.mas_left).offset(-10);
        make.right.equalTo(self.textField.mas_right).offset(10);
        make.top.equalTo(self.textField.mas_bottom);
        make.height.equalTo(@2);
    }];
    
    
    commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = RGBACOLOR(43, 173, 63, 1);
    [commitBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [commitBtn addTarget:self action:@selector(changeName) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.layer.cornerRadius = 4;
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xian.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.height.equalTo(@38);
    }];
    
}


- (void)changeName
{
    [self.view endEditing:YES];
    if (![self.textField.text isPhoneNum]) {
        [self showErrorTips:@"号码有误"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(orderCusPhone:)]) {
        [self.delegate orderCusPhone:self.textField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
