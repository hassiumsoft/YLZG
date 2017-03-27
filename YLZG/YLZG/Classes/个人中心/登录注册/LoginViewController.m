//
//  LoginViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "LoginViewController.h"
#import <UMMobClick/MobClick.h>
#import "UserInfoManager.h"
#import <Masonry.h>
#import "HomeNavigationController.h"
#import <MJExtension.h>
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import <JPUSHService.h>
#import "AboutZhichengController.h"
#import "ClearCacheTool.h"

@interface LoginViewController ()

/** 头像 */
@property (strong,nonatomic) UIImageView *imageV;
/** 登录名 */
@property (strong,nonatomic) UITextField *nameField;
/** 密码 */
@property (strong,nonatomic) UITextField *passField;
/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self setupSubViews];
}
#pragma mark - 点击登录
- (void)loginAction
{
    [self.view endEditing:YES];
    
    if (self.nameField.text.length < 1) {
        [self showErrorTips:@"账户名不能为空"];
        return;
    }
    if (self.passField.text.length < 1) {
        [self showErrorTips:@"密码不能为空"];
        return;
    }
    [MBProgressHUD showMessage:@"登录中···"];
    [[YLZGDataManager sharedManager] loginWithUserName:self.nameField.text PassWord:self.passField.text Success:^{
        
        [MBProgressHUD hideHUD];
        HomeTabbarController *tabbar = [[HomeTabbarController alloc]init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.8;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        animation.subtype = kCATransitionFromBottom;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        window.rootViewController = tabbar;
        [window makeKeyAndVisible];
        
    } Fail:^(NSString *errorMsg) {
        [MBProgressHUD hideHUD];
        [self sendErrorWarning:errorMsg];
    }];
    
}

#pragma mark - 绘制UI
- (void)setupSubViews
{
    if (SCREEN_WIDTH == 375) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg_ip6"]]; // 6机型特殊
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]; // cm2_fm_bg
    }
    
    // 头像
    self.imageV = [[UIImageView alloc]init];
    [self.imageV setImage:[UIImage imageNamed:@"loginheaderImage"]];
    [self.view addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(140*CKproportion);
        make.width.and.height.equalTo(@80);
    }];
    
    // 登录名
    self.nameField = [[UITextField alloc]init];
    self.nameField.background = [UIImage imageNamed:@"userImage"];
    self.nameField.placeholder = @"影楼ERP登录名";
    NSUserDefaults * us = [NSUserDefaults standardUserDefaults];
    self.nameField.text = [us objectForKey:UDLoginUserName];
    self.nameField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameField.keyboardType = UIKeyboardTypeDefault;
    self.nameField.tintColor = [UIColor whiteColor];
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.textColor = [UIColor whiteColor];
    self.nameField.textAlignment = NSTextAlignmentCenter;
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.nameField.placeholder attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote],NSForegroundColorAttributeName:RGBACOLOR(247, 247, 247, 0.9)}];
    [self.view addSubview:self.nameField];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.height.equalTo(@46);
        make.top.equalTo(self.imageV.mas_bottom).offset(45);
    }];
    
    
    // 登录名
    self.passField = [[UITextField alloc]init];
    self.passField.background = [UIImage imageNamed:@"passworkImage"];
    self.passField.placeholder = @"ERP密码";
    self.passField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.passField.secureTextEntry = YES;
    self.passField.tintColor = [UIColor whiteColor];
    self.passField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passField.textColor = [UIColor whiteColor];
    self.passField.textAlignment = NSTextAlignmentCenter;
    self.passField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:self.passField.placeholder attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote],NSForegroundColorAttributeName:RGBACOLOR(247, 247, 247, 0.9)}];
    [self.view addSubview:self.passField];
    [self.passField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.height.equalTo(@46);
        make.top.equalTo(self.nameField.mas_bottom).offset(28);
    }];
    
    // 登录按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = RGBACOLOR(31, 139, 229, 1);
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 20;
    [loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passField.mas_bottom).offset(33);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.height.equalTo(@43);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    // 了解智诚
    UIButton *liaojieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [liaojieBtn setTitle:@"了解智诚" forState:UIControlStateNormal];
    [liaojieBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    liaojieBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    [liaojieBtn addTarget:self action:@selector(liaojieZhichengAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:liaojieBtn];
    [liaojieBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-1);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@40);
    }];
    
    
    // 底部小线
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jianbiansetiao"]];
    [self.view addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@1);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.bottom.equalTo(liaojieBtn.mas_top).offset(-1);
    }];
    
    if (SCREEN_WIDTH == 320) {
        [xian removeFromSuperview];
    }
    
}

#pragma mark - 了解智诚
- (void)liaojieZhichengAction
{
    AboutZhichengController *about = [AboutZhichengController new];
    about.isLogin = NO;
    [self presentViewController:about animated:YES completion:^{
        
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [MobClick beginLogPageView:@"登录界面"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}


@end
