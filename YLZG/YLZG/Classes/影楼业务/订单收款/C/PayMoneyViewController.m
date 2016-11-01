//
//  PayMoneyViewController.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/19.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "PayMoneyViewController.h"
#import "UIImageView+WebCache.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <SVProgressHUD.h>

@interface PayMoneyViewController ()

@property (strong,nonatomic) NSMutableArray *buttonArray;

@property (strong,nonatomic) UIImageView *imageV;

@property (strong,nonatomic) UITextField *moneyField;

@property (copy,nonatomic) NSString *alipay_url;
@property (copy,nonatomic) NSString *wechatpay_url;

@end

@implementation PayMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    [self getData];
    
    
}
- (void)getData
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *str = [NSString stringWithFormat:ErweimaImage_Url,account.userID,@""];
    NSCharacterSet * set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString * url = [str stringByAddingPercentEncodingWithAllowedCharacters:set];
    [SVProgressHUD showWithStatus:@"获取中···"];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"]description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            [SVProgressHUD dismiss];
            self.alipay_url = [[responseObject objectForKey:@"alipay"] description];
            self.wechatpay_url = [[responseObject objectForKey:@"weipay"] description];
            [self setupSubViews];
        }else{
            [SVProgressHUD dismiss];
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}
- (void)setupSubViews
{
    
    self.payType = WechatPayType;
    // 选择支付方式
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    label1.text = @"    请选择支付方式";
    label1.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.view addSubview:label1];
    // 选择父视图
    UIView *changeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), SCREEN_WIDTH, 55)];
    changeView.userInteractionEnabled = YES;
    changeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:changeView];
    
    NSArray *titleArr = @[@"微信",@"支付宝",@"现金",@"POS刷卡"];
    CGFloat W = SCREEN_WIDTH/4;
    CGFloat H = 55;
    CGFloat Y = 0;
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
        }
        button.tag = i + 1;
        button.titleLabel.font = [UIFont systemFontOfSize:15*CKproportion];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(i * W, Y, W, H)];
        [changeView addSubview:button];
        
        [self.buttonArray addObject:button];
    }
    
    // 二维码图片
    self.imageV = [[UIImageView alloc]init];
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    self.imageV.backgroundColor = [UIColor whiteColor];
    [self.imageV setFrame:CGRectMake(0, CGRectGetMaxY(changeView.frame) + 12, SCREEN_WIDTH, self.view.height - 55 - 40 - 12- 200)];
    [self.view addSubview:self.imageV];
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.wechatpay_url] placeholderImage:[UIImage imageNamed:@"meng_bg"]];
    
    // 输入金额
    UIView *moneyView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageV.frame) + 12, SCREEN_WIDTH, 50)];
    moneyView.backgroundColor = [UIColor whiteColor];
    moneyView.userInteractionEnabled = YES;
    [self.view addSubview:moneyView];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH * 0.6, 50)];
    label2.font = [UIFont systemFontOfSize:15*CKproportion];
    label2.text = @"请输入支付成功后的金额：";
    [moneyView addSubview:label2];
    
    self.moneyField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.6, 0, SCREEN_WIDTH * 0.4 - 20, 50)];
    self.moneyField.text = self.price;
    self.moneyField.textAlignment = NSTextAlignmentRight;
    self.moneyField.keyboardType = UIKeyboardTypeNumberPad;
    [moneyView addSubview:self.moneyField];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"客户支付完成" forState:UIControlStateNormal];
    sendButton.backgroundColor = MainColor;
    sendButton.layer.cornerRadius = 6;
    sendButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [sendButton addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setFrame:CGRectMake(20, CGRectGetMaxY(moneyView.frame) + 18, SCREEN_WIDTH - 40, 40)];
    [self.view addSubview:sendButton];
    
}


- (void)finished
{
    [self.view endEditing:YES];
    
    if (self.moneyField.text.length < 1) {
        [self showErrorTips:@"请填写支付金额"];
        return;
    }
    
    
//    http://zsylou.wxwkf.com/index.php/home/PayTrade/pay?uid=159&type=2&money=800&trade_id=20160622-002
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",nil];
    ZCAccount *account = [ZCAccountTool account];
    NSString *str = [NSString stringWithFormat:FinishedPayOrder_Url,account.userID,(int)self.payType,self.moneyField.text,self.orderID];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *url = [str stringByAddingPercentEncodingWithAllowedCharacters:set];
    [SVProgressHUD showWithStatus:@"请稍后···"];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            int code = [[[json objectForKey:@"code"] description] intValue];
            NSString *message = [[json objectForKey:@"message"] description];
            [SVProgressHUD dismiss];
            if (code == 1) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                
                [alertC addAction:action1];
                [self presentViewController:alertC animated:YES completion:^{
                    
                }];
            }else if (code == 0){
                NSString *errorMsg = @"失败，当前订单之前有过支付记录。请核对后台信息。";
                [self sendErrorWarning:errorMsg];
            }else{
                [self sendErrorWarning:message];
            }
        } else {
            [SVProgressHUD dismiss];
            [self sendErrorWarning:@"数据异常"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self sendErrorWarning:error.localizedDescription];
    }];
}

- (void)buttonClick:(UIButton *)sender
{
    for (UIButton *button in self.buttonArray) {
        [button setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    }
    [sender setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
    self.payType = sender.tag;
    
    switch (self.payType) {
        case WechatPayType:
        {
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.wechatpay_url] placeholderImage:[UIImage imageNamed:@"meng_bg"]];
            break;
        }
        case ZhifubaoType:
        {
            [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.alipay_url] placeholderImage:[UIImage imageNamed:@"meng_bg"]];
            break;
        }
        case CashType:
        {
            [self.imageV setImage:[UIImage imageNamed:@"ico_xianjian"]];
            break;
        }
        case BankCarPayType:
        {
            [self.imageV setImage:[UIImage imageNamed:@"ic_swipe_in"]];
            break;
        }
        default:
            break;
    }
    
}

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc]init];
    }
    return _buttonArray;
}

@end
