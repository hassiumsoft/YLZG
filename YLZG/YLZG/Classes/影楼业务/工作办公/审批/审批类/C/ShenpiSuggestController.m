//
//  ShenpiSuggestController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/25.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "ShenpiSuggestController.h"
#import "ZCAccountTool.h"
#import "HTTPManager.h"
#import <Masonry.h>

#define agreeText @"如：同意。注意······（非必填）"
#define disAgreeText @"如：不同意。······（非必填）"

@interface ShenpiSuggestController ()<UITextViewDelegate>

@property (strong,nonatomic) UITextView *textView;

@property (strong,nonatomic) UIButton *commitBtn;

@property (strong,nonatomic) UIActivityIndicatorView *indicatorV;

@end

@implementation ShenpiSuggestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审批意见";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, SCREEN_HEIGHT * 0.18)];
    if (self.isAgree) {
        self.textView.text = agreeText;
    }else{
        self.textView.text = disAgreeText;
    }
    self.textView.delegate = self;
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    
    self.commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitBtn.backgroundColor = MainColor;
    [self.commitBtn setFrame:CGRectMake(12, CGRectGetMaxY(self.textView.frame) + 15, SCREEN_WIDTH - 24, 40)];
    self.commitBtn.layer.cornerRadius = 4;
    [self.commitBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commitBtn];
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.isAgree) {
        if ([textView.text isEqualToString:agreeText]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }else{
        if ([textView.text isEqualToString:disAgreeText]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.isAgree) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = agreeText;
            textView.textColor = [UIColor lightGrayColor];
        }
    }else{
        if ([textView.text isEqualToString:@""]) {
            textView.text = disAgreeText;
            textView.textColor = [UIColor lightGrayColor];
        }
    }
}

#pragma mark - 发送意见
- (void)commitAction:(UIButton *)sender
{
    [sender setTitle:@"" forState:UIControlStateNormal];
    [self.indicatorV startAnimating];
    
    NSString *details;
    
    if ([self.textView.text isEqualToString:disAgreeText]) {
        details = @"不同意";
    }else if ([self.textView.text isEqualToString:agreeText]) {
        details = @"同意";
    }else{
        details = self.textView.text;
    }
    
    NSString *option;
    if (self.isAgree) {
        option = @"1";
    }else{
        option = @"2";
    }
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:shenpiSuggest,self.model.id,self.model.kind,option,details,account.userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *message = [[responseObject objectForKey:@"message"] description];
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        [self.indicatorV stopAnimating];
        [sender setTitle:@"确 定" forState:UIControlStateNormal];
        if (status == 1) {
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 发出通知，告诉前面的VC请求数据并刷新界面
                [YLNotificationCenter postNotificationName:YLReloadShenpiData object:option];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertC addAction:action1];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
        }else{
            [self sendErrorWarning:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.indicatorV stopAnimating];
        [sender setTitle:@"确 定" forState:UIControlStateNormal];
        [self sendErrorWarning:[NSString stringWithFormat:@"%@(申请成功，推送失败。)",error.localizedDescription]];
        [YLNotificationCenter postNotificationName:YLReloadShenpiData object:option];
    }];
    
}

- (UIActivityIndicatorView *)indicatorV
{
    if (!_indicatorV) {
        _indicatorV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_commitBtn addSubview:_indicatorV];
        [_indicatorV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.commitBtn.mas_centerX);
            make.centerY.equalTo(self.commitBtn.mas_centerY);
            make.width.and.height.equalTo(@40);
        }];
    }
    return _indicatorV;
}

@end
