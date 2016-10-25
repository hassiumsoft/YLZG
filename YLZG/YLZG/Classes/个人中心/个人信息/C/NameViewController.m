//
//  NameViewController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/19.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "NameViewController.h"
#import "ZCAccountTool.h"
#import "UserInfoManager.h"
#import <Masonry.h>
#import "HTTPManager.h"




@interface NameViewController ()<UITextFieldDelegate>

{
    UIButton *commitBtn;
}

/** 菊花 */
@property (strong,nonatomic) UIActivityIndicatorView *indicator;
@property (strong,nonatomic) UITextField *textField;


@end

@implementation NameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置昵称";
    [self createUI];
}

- (void)createUI {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = @"建议使用真名";
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
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.backgroundColor = [UIColor whiteColor];
    UserInfoModel *model = [UserInfoManager getUserInfo];
    self.textField.placeholder = model.nickname;
    self.textField.delegate = self;
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
    [commitBtn setTitle:@"保  存" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [commitBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.layer.cornerRadius = 4;
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xian.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.height.equalTo(@38);
    }];
    
}

- (void)leftBtn:(UIButton *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击确定修改
- (void)sendAction:(UIButton *)button {
    
    /************ 上传到环信的服务器 ************/
    //获取文本输入框
    if((self.textField.text.length > 0) && (![self.textField.text isEqualToString:self.textField.placeholder]))
    {
        //设置推送设置 updateUserProfileInBackground
        [button setTitle:@"" forState:UIControlStateNormal];
        [self.indicator startAnimating];
        
        ZCAccount * account = [ZCAccountTool account];
        NSString *url = [NSString stringWithFormat:UploadNickNameURL,self.textField.text,account.userID];
        [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            NSString *message = [[responseObject objectForKey:@"message"] description];
            [self hideHud:0];
            if (code == 1) {
                [UserInfoManager updataUserInfoWithKey:@"nickname" Value:self.textField.text];
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [YLNotificationCenter postNotificationName:HXUpdataContacts object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                [alertC addAction:action1];
                [self presentViewController:alertC animated:YES completion:^{
                    
                }];
            }else{
                [self showErrorTips:message];
            }
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            [self showErrorTips:error.localizedDescription];
        }];
    }
    
}

///************ 上传到自己的服务器 ************/
//- (void)uploadMyNickName:(NSString *)myNickName {
//    
//    if (self.textField.text.length > 0) {
//        
//        ZCAccount * account = [ZCAccountTool account];
//        NSString * str = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/contacts/update?nickname=%@&uid=%@",myNickName,account.userID];
//        NSCharacterSet * set = [NSCharacterSet URLQueryAllowedCharacterSet];
//        NSString * url = [str stringByAddingPercentEncodingWithAllowedCharacters:set];
//        [AFHTTPSessionManager GETOder:url parameter:nil success:^(id responseObject) {
//            [self.indicator stopAnimating];
//            NSError * error;
//            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
//            if (error) {
//                [self sendErrorWarning:[NSString stringWithFormat:@"%@", error.localizedDescription]];
//            }else {
//                int status = [[dict[@"code"] description] intValue];
//                if (status == 1) {
//                    KGLog(@"修改昵称成功");
//                    UserProfileEntity * entity = [[UserProfileManager sharedInstance] getCurUserProfile];
//                    entity.nickname = self.textField.text;
//                    [YLNotificationCenter postNotificationName:YLNickNameChanged object:self.textField.text];
//                    [self.indicator stopAnimating];
//                    
//                    BOOL result = [UserInfoManager updataUserInfoWithKey:@"nickname" Value:self.textField.text];
//                    
//                    if (result) {
//                        [self sendSuccessMessage:@"信息修改成功"];
//                    }
//                    
//                    
//                }else {
//                    NSString *message = [[dict objectForKey:@"message"] description];
//                    [self sendErrorWarning:message];
//                }
//            }
//        } failure:^(NSError *error) {
//            [self sendErrorWarning:[NSString stringWithFormat:@"%@", error.localizedDescription]];
//        }];
//    }
//    
//}

//- (void)sendSuccessMessage:(NSString *)message
//{
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        [YLNotificationCenter postNotificationName:HXUpdataContacts object:nil];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//    
//    [alertC addAction:action1];
//    [self presentViewController:alertC animated:YES completion:^{
//        
//    }];
//}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [commitBtn addSubview:_indicator];
        [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->commitBtn.mas_centerX);
            make.centerY.equalTo(self->commitBtn.mas_centerY);
            make.width.and.height.equalTo(@35);
        }];
    }
    return _indicator;
}




@end
