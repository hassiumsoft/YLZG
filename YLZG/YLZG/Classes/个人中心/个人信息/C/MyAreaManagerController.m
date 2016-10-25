//
//  MyAreaManagerController.m
//  YLZG
//
//  Created by Chan_Sir on 16/8/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MyAreaManagerController.h"
#import <Masonry.h>
#import "ZCAccountTool.h"
#import <MJExtension.h>
#import "HTTPManager.h"
#import "NSString+StrCategory.h"



@interface AreaManagerModel : NSObject

@property (copy,nonatomic) NSString *id;

@property (copy,nonatomic) NSString *name;

@property (copy,nonatomic) NSString *phone;



@end

@implementation AreaManagerModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

/************* 本类 ****************/


@interface MyAreaManagerController ()

@property (strong,nonatomic) AreaManagerModel *model;

@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) UILabel *titleLabel;

@property (strong,nonatomic) UILabel *phoneLabel;


@end

@implementation MyAreaManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的区域经理";
    self.view.backgroundColor = NavColor;
    self.view.layer.borderColor = [UIColor redColor].CGColor;
    self.view.layer.borderWidth= 1.f;
    self.view.layer.cornerRadius = 12;
    [self setupSubViews];
}

- (void)setupSubViews
{
    
    // 名字
    self.nameLabel = [[UILabel alloc]init];
    _nameLabel.text = @"无名氏";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _nameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview: _nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-45);
        make.height.equalTo(@23);
    }];
    
    
    
    // 标题
    self.titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"联系区域经理";
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(7);
        make.height.equalTo(@30);
    }];
    
    
    [self.view addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.self.nameLabel.mas_bottom);
        make.height.equalTo(@22);
    }];
    
    // 返回按钮
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"×" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-3);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@24);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        
        if (![self.model.phone isPhoneNum]) {
            [self showErrorTips:@"手机号码无效"];
        }
        
        NSURL *phoheURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.model.phone]];
        UIWebView *phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoheURL]];
        [self.view addSubview:phoneWebView];
    }];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phoneLabel"]];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.userInteractionEnabled = YES;
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(12);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.and.height.equalTo(@60);
    }];
    
    [imageV addGestureRecognizer:tap];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getInfo];
    

}
- (void)reloadData
{
    self.nameLabel.text = self.model.name;
    self.phoneLabel.text = self.model.phone;
}


- (void)getInfo
{
    ZCAccount *account = [ZCAccountTool account];
    //    ContactManager_Url
    NSString *url = [NSString stringWithFormat:ContactManager_Url,account.userID];
//    NSCharacterSet * set = [NSCharacterSet URLQueryAllowedCharacterSet];
//    NSString * url = [str stringByAddingPercentEncodingWithAllowedCharacters:set];
    [self showHudMessage:@"Calling···"];
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideHud:0];
        KGLog(@"responseObject = %@",responseObject);
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self showErrorTips:error.localizedDescription];
    }];
    
//    [AFHTTPSessionManager getCache:url parameter:nil success:^(id responseObject) {
//        NSError *error;
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
//        
//        if (!error) {
//            int code = [[[json objectForKey:@"code"]description] intValue];
//            NSString *message = [[json objectForKey:@"message"] description];
//            if (code == 1) {
//                KGLog(@"json = %@",json);
//                [self hideHud:0];
//                NSDictionary *dict = [json objectForKey:@"result"];
//                self.model = [AreaManagerModel mj_objectWithKeyValues:dict];
//                [self reloadData];
//            }else{
////                [self reloadData];
//                [self showErrorTips:message];
//                [self hideHud:2];
//                
//            }
//        }else{
//            [self showErrorTips:@"解析失败"];
//        }
//        
//    } failure:^(NSError *error) {
//        [self hideHud:1];
//        [self showErrorTips:error.localizedDescription];
//    }];
    
}
- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text = @"135****5114";
        _phoneLabel.textColor = [UIColor whiteColor];
        _phoneLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneLabel;
}
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end

