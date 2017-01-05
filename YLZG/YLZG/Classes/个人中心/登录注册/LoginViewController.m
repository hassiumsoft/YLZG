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
    
//    self.nameField.text = @"whdmx_whdmx";
//    self.passField.text = @"710321";
//    [[EMClient sharedClient] registerWithUsername:self.nameField.text password:self.passField.text completion:^(NSString *aUsername, EMError *aError) {
//        if (aError) {
//            [self sendErrorWarning:aError.errorDescription];
//        }
//    }];
//    
//    return;
    
    if (self.nameField.text.length < 1) {
        [self showErrorTips:@"账户名不能为空"];
        return;
    }
    if (self.passField.text.length < 1) {
        [self showErrorTips:@"密码不能为空"];
        return;
    }
    
    
    NSString *deviceName = [UIDevice currentDevice].name;
    CGFloat deviceVersion = [[UIDevice currentDevice].systemVersion floatValue];
    
    NSString *deviceInfo = [NSString stringWithFormat:@"%@_%g",deviceName,deviceVersion];
    deviceInfo = [deviceInfo stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *url = [NSString stringWithFormat:YLLoginURL,self.nameField.text,self.passField.text,deviceInfo];
    [self showHudMessage:@"登录中···"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideHud:0];
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:result];
            if ([model.is_register_easemob boolValue]) {
                // 已经注册环信，登录环信
                [[EMClient sharedClient] loginWithUsername:self.nameField.text password:self.passField.text completion:^(NSString *aUsername, EMError *aError) {
                    
                    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
                    [UD setObject:self.nameField.text forKey:UDLoginUserName];
                    [UD synchronize];
                    
                    if (!aError) {
                        // 登录环信成功
                        [self saveUserInfoAction:result Complete:^{
                            
                            HomeTabbarController *homeTab = [HomeTabbarController new];
                            CATransition *animation = [CATransition animation];
                            animation.duration = 0.8;
                            animation.timingFunction = UIViewAnimationCurveEaseInOut;
                            animation.type = kCATransitionFade;
                            animation.subtype = kCATransitionFromBottom;
                            [self.view.window.layer addAnimation:animation forKey:nil];
                            [self presentViewController:homeTab animated:NO completion:^{
                                
                            }];
                        }];
                        
                    }else{
                        // 登录环信失败
                        NSString *errorMsg = [NSString stringWithFormat:@"HXError:%@",aError.errorDescription];
                        [self sendErrorWarning:errorMsg];
                    }
                }];
                
            }else{
                // 没有注册环信
                
            }
        }else{
            // 登录智诚服务器失败
            [self sendErrorWarning:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
}
#pragma mark - 用户信息缓存的操作
- (void)saveUserInfoAction:(NSDictionary *)json Complete:(LoginCompleteBlock)block
{
    
    // 友盟
    [MobClick profileSignInWithPUID:self.nameField.text];
    
    // 到这步就可以把账户信息归档
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    
    // 比较和之前的账号是否一致
    UserInfoModel *loginedModel = [UserInfoManager getUserInfo];
    if ([self.nameField.text isEqualToString:loginedModel.username]) {
        // 和刚刚已退出的账号一致，不删除.但是需要替换更新的用户数据
        /** ⚠️ 使用FMDB存储更新的数据 */
        UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:json];
        model.password = self.passField.text;
        model.username = self.nameField.text;
        [UserInfoManager saveInfoToSandBox:model];
        
        newDic[@"username"] = model.username;
        newDic[@"password"] = model.password;
        newDic[@"userID"] = model.uid;
        
        ZCAccount *account = [ZCAccount accountWithDict:newDic];
        [ZCAccountTool saveAccount:account];
        
        // 删除data缓存
        [HTTPManager ClearCacheDataCompletion:^{
            
        }];
        
        // 设置自动登录
        [EMClient sharedClient].options.isAutoLogin = YES;
        [EMClient sharedClient].pushOptions.displayName = model.realname.length>0 ? model.realname : model.nickname;
        [EMClient sharedClient].pushOptions.displayStyle = EMPushDisplayStyleMessageSummary;
        
        
        // 极光推送
        [JPUSHService setTags:[NSSet setWithObject:model.sid] aliasInbackground:model.uid];
        [[EMClient sharedClient] setApnsNickname:model.realname];
        
        block();
    }else{
        // 另外一个账号，删除之前的记录
        [self clearSomeDataComplete:^{
            /** ⚠️ 使用FMDB存储数据 */
            UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:json];
            model.password = self.passField.text;
            model.username = self.nameField.text;
            [UserInfoManager saveInfoToSandBox:model];
            
            newDic[@"username"] = model.username;
            newDic[@"password"] = model.password;
            newDic[@"userID"] = model.uid;
            
            ZCAccount *account = [ZCAccount accountWithDict:newDic];
            [ZCAccountTool saveAccount:account];
            
            
            // 设置自动登录
            [EMClient sharedClient].options.isAutoLogin = YES;
            [EMClient sharedClient].pushOptions.displayName = model.realname.length>0 ? model.realname : model.nickname;
            [EMClient sharedClient].pushOptions.displayStyle = EMPushDisplayStyleMessageSummary;
            
            
            // 极光推送
            [JPUSHService setTags:[NSSet setWithObject:model.sid] aliasInbackground:model.uid];
            [[EMClient sharedClient] setApnsNickname:model.realname];
            
            block();
        }];
    }
    
}
#pragma mark - 如果和之前的登录账号一致，则不需删除沙盒数据
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
