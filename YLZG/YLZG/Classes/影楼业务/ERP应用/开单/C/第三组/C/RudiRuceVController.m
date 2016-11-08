//
//  RudiRuceVController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "RudiRuceVController.h"
#import <Masonry.h>

@interface RudiRuceVController ()

{
    UIButton *commitBtn;
}

@property (strong,nonatomic) UITextField *textField;

@end

@implementation RudiRuceVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

- (void)createUI {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    if (self.rudiruceType) {
        label.text = @"编辑入底";
    }else{
        label.text = @"编辑入册";
    }
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
    self.textField.placeholder = @"如：30";
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
    commitBtn.backgroundColor = MainColor;
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
        make.height.equalTo(@40);
    }];
    
}


- (void)changeName
{
    [self.view endEditing:YES];
    
    if (self.RudiRuceBlock) {
        _RudiRuceBlock(self.textField.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
