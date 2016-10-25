//
//  MyStudioVController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/30.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "MyStudioVController.h"
#import "UserInfoManager.h"
#import "HTTPManager.h"
#import "ZCAccountTool.h"
//#import "DetialButton.h"
#import <Masonry.h>


@interface MyStudioVController ()<UIWebViewDelegate>

@property (copy,nonatomic) NSString *url;

@property (strong,nonatomic) UIWebView *webView;

@end

@implementation MyStudioVController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
}

- (void)getData
{
    UserInfoModel *model = [UserInfoManager getUserInfo];
    self.title = model.store_simple_name;
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:MyStido_Url,account.userID];
    
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *dictionary = [responseObject objectForKey:@"result"];
            NSString *url = [dictionary objectForKey:@"url"];
            [self setupSubViews:url];
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
    
    
}

- (void)setupSubViews:(NSString *)str
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showErrorTips:error.localizedDescription];
    
}

@end
