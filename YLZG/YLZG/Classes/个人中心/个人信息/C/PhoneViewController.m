//
//  PhoneViewController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/19.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "PhoneViewController.h"
#import "NSString+StrCategory.h"
#import "ZCAccountTool.h"
#import <LCActionSheet.h>
#import "UserInfoManager.h"
#import <Masonry.h>
#import "HTTPManager.h"

@interface PhoneViewController ()<UITextFieldDelegate,LCActionSheetDelegate>

{
    UIButton *commitBtn;
}

/** 没有添加手机的界面属性 **/
@property (strong,nonatomic) UIActivityIndicatorView *indicator1;
@property (strong,nonatomic) UITextField *textField;
@property (strong,nonatomic) UIImageView *xian;
@property (strong,nonatomic) UILabel *label;
/** 已添加手机的界面属性 */
@property (strong,nonatomic) UIImageView *imageV;
@property (strong,nonatomic) UILabel *phoneLabel;
@property (strong,nonatomic) UILabel *descLabel;
@property (strong,nonatomic) UIButton *changePhoneBtn;
@property (strong,nonatomic) UIActivityIndicatorView *indicator2;

@end

@implementation PhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号码";
    self.view.backgroundColor = [UIColor whiteColor];
    UserInfoModel *model = [UserInfoManager getUserInfo];
    
    if ([model.mobile isPhoneNum]) {
        self.phoneStr = model.mobile;
        [self setupPhoneVies];
    }else{
        [self setupNoPhoneViews];
    }
}

#pragma mark - 没有绑定手机号码的界面
- (void)setupNoPhoneViews
{
    self.label = [[UILabel alloc]initWithFrame:CGRectZero];
    self.label.text = @"请输入您的手机号";
    self.label.font = [UIFont systemFontOfSize:24];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@24);
        make.top.equalTo(self.view.mas_top).offset(100);
    }];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(40, 200*CKproportion, SCREEN_WIDTH - 80, 45)];
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(12, 0, 0, 0)];
    [self.textField becomeFirstResponder];
    self.textField.background = [UIImage imageNamed:@""];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.backgroundColor = [UIColor whiteColor];
    
    if (self.phoneStr) {
        self.textField.placeholder = [NSString stringWithFormat:@"如：%@",self.phoneStr];
    }else{
        self.textField.placeholder = @"如：18233568284";
    }
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    
    self.xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self.view addSubview:_xian];
    [_xian mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [commitBtn addTarget:self action:@selector(sendNewPhone:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.layer.cornerRadius = 4;
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xian.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.height.equalTo(@40);
    }];
}

#pragma mark - 点击绑定手机号
- (void)sendNewPhone:(UIButton *)sender
{
    if (![self.textField.text isPhoneNum]) {
        [self sendErrorWarning:@"手机号码不正确"];
        return;
    }
    if ([self.textField.text isEqualToString:self.phoneStr]) {
        [self sendErrorWarning:@"手机号码没变化"];
        return;
    }
    
    [self.view endEditing:YES];
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self.indicator1 startAnimating];
    
    /************ 上传到自己的服务器 ************/
    if ((self.textField.text.length > 0) && (![self.textField.text isEqualToString:self.phoneStr])) {
        
        ZCAccount * account = [ZCAccountTool account];
        NSString * url = [NSString stringWithFormat:UploadMobieURL,self.textField.text,account.userID];
        
        [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            if (code == 1) {
                [self.indicator1 stopAnimating];
                [sender setTitle:@"确  定" forState:UIControlStateNormal];
                
                [self.label removeFromSuperview];
                [self.textField removeFromSuperview];
                [self.xian removeFromSuperview];
                [self->commitBtn removeFromSuperview];
                NSUserDefaults *userDefault = USER_DEFAULT;
                [userDefault setObject:self.textField.text forKey:@"userPhone"];
                [userDefault synchronize];
                [UserInfoManager updataUserInfoWithKey:@"mobile" Value:self.textField.text];
                
                [self setupPhoneVies];
            }else{
                [self showErrorTips:message];
            }
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            [self showErrorTips:error.localizedDescription];
        }];
        
//        NSCharacterSet * set = [NSCharacterSet URLQueryAllowedCharacterSet];
//        NSString * url = [str stringByAddingPercentEncodingWithAllowedCharacters:set];
//        [AFHTTPSessionManager GETOder:url parameter:nil success:^(id responseObject) {
//            NSError * error;
//            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
//            if (error) {
//                [self sendErrorWarning:[NSString stringWithFormat:@"%@", error.localizedDescription]];
//            }else {
//                [self.indicator1 stopAnimating];
//                [sender setTitle:@"提  交" forState:UIControlStateNormal];
//                int status = [[dict[@"code"]description] intValue];
//                if (status == 1) {
//                    
//                    NSUserDefaults *userDefault = USER_DEFAULT;
//                    [userDefault setObject:self.textField.text forKey:@"userPhone"];
//                    [userDefault synchronize];
//                    
//                    [self.indicator1 stopAnimating];
//                    [sender setTitle:@"确  定" forState:UIControlStateNormal];
//                    
//                    [self.label removeFromSuperview];
//                    [self.textField removeFromSuperview];
//                    [self.xian removeFromSuperview];
//                    [self->commitBtn removeFromSuperview];
//                    
////                    [YLNotificationCenter postNotificationName:HXUpdataContacts object:nil];
//                    [UserInfoManager updataUserInfoWithKey:@"mobile" Value:self.textField.text];
//                    
//                    [self setupPhoneVies];
//                    
//                }else {
//                    NSString * message = [[dict objectForKey:@"message"] description];
//                    [self sendErrorWarning:message];
//                }
//            }
//        } failure:^(NSError *error) {
//            [self.indicator1 stopAnimating];
//            [sender setTitle:@"提  交" forState:UIControlStateNormal];
//            [self sendErrorWarning:[NSString stringWithFormat:@"%@", error.localizedDescription]];
//        }];
    }
}
#pragma mark - 已绑定的界面
- (void)setupPhoneVies
{
    self.imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checked_phone"]];
    [self.view addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(138*CKproportion);
        make.width.and.height.equalTo(@160);
    }];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *kkk = [[userDefault objectForKey:@"userPhone"] description];
    if (kkk.length == 11) {
        self.phoneStr = kkk;
    }
    self.phoneLabel = [[UILabel alloc]init];
    if (self.phoneStr) {
        self.phoneLabel.text = [NSString stringWithFormat:@"当前手机号：%@",self.phoneStr];
    }else{
        self.phoneLabel.text = [NSString stringWithFormat:@"当前手机号：%@",self.textField.text];
    }
    self.phoneLabel.font = [UIFont systemFontOfSize:20];
    self.phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.imageV.mas_bottom).offset(20);
        make.height.equalTo(@24);
    }];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel.text = @"此手机号方便您在影楼\n工作中实现高效沟通";
    self.descLabel.font = [UIFont systemFontOfSize:16];
    self.descLabel.textColor = [UIColor grayColor];
    self.descLabel.numberOfLines = 0;
    [self.view addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(14);
        make.height.equalTo(@44);
    }];
    
    self.changePhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changePhoneBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
    self.changePhoneBtn.backgroundColor = RGBACOLOR(43, 173, 63, 1);
    [self.changePhoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.changePhoneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.changePhoneBtn addTarget:self action:@selector(changePhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    self.changePhoneBtn.layer.cornerRadius = 4;
    [self.view addSubview:self.changePhoneBtn];
    [self.changePhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.top.equalTo(self.descLabel.mas_bottom).offset(16);
        make.height.equalTo(@40);
    }];
}

#pragma mark - 解绑手机号
- (void)changePhoneAction:(UIButton *)sender
{
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确定更改手机号？" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self.indicator2 stopAnimating];
            
            [self.changePhoneBtn removeFromSuperview];
            [self.descLabel removeFromSuperview];
            [self.phoneLabel removeFromSuperview];
            [self.imageV removeFromSuperview];
            
            [self setupNoPhoneViews];
        }
    } otherButtonTitles:@"确定修改", nil];
    sheet.destructiveButtonIndexSet = [NSSet setWithObject:@1];
    [sheet show];
    
}


- (UIActivityIndicatorView *)indicator1
{
    if (!_indicator1) {
        _indicator1 = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [commitBtn addSubview:_indicator1];
        [_indicator1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->commitBtn.mas_centerX);
            make.centerY.equalTo(self->commitBtn.mas_centerY);
            make.width.and.height.equalTo(@35);
        }];
    }
    return _indicator1;
}

- (UIActivityIndicatorView *)indicator2
{
    if (!_indicator2) {
        _indicator2 = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_changePhoneBtn addSubview:_indicator2];
        [_indicator2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.changePhoneBtn.mas_centerX);
            make.centerY.equalTo(self.changePhoneBtn.mas_centerY);
            make.width.and.height.equalTo(@35);
        }];
    }
    return _indicator2;
}

- (void)sendSuccess:(NSString *)message
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}

@end
