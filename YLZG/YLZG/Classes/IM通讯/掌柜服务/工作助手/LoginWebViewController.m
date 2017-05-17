//
//  LoginWebViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "LoginWebViewController.h"
#import "WXApi.h"
#import <LCActionSheet.h>

@interface LoginWebViewController ()<UIWebViewDelegate>

{
    BOOL theBool;
    UIProgressView* myProgressView;
    NSTimer *myTimer;
}

@property (strong,nonatomic) LoginInfoModel *loginModel;

@property (strong,nonatomic) UIWebView *webView;

@end

@implementation LoginWebViewController

- (instancetype)initWithLoginModel:(LoginInfoModel *)loginModel
{
    self = [super init];
    if (self) {
        self.loginModel = loginModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.loginModel.title;
    [self setupSubViews];
    [self addProgressView];
}
#pragma mark - 添加网页
- (void)setupSubViews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    self.webView.backgroundColor = self.view.backgroundColor;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.loginModel.url]];
    [self.webView loadRequest:request];
}


- (void)shareAction
{
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self shareWebPagetoWechat:self.loginModel.url Type:0];
        }else if(buttonIndex == 2){
            [self shareWebPagetoWechat:self.loginModel.url Type:1];
        }
        
    } otherButtonTitles:@"微信好友",@"朋友圈", nil];
    [sheet show];
}

#pragma mark - 分享网页链接
- (void)shareWebPagetoWechat:(NSString *)url Type:(int)shareType
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.loginModel.title;
    message.description = self.loginModel.content;
    [message setThumbImage:[UIImage imageNamed:@"app_logo"]];
    
    WXWebpageObject *webObject = [WXWebpageObject object];
    webObject.webpageUrl = url;
    message.mediaObject = webObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = shareType;
    [WXApi sendReq:req];
    
}


#pragma mark - 添加加载进度条
- (void)addProgressView
{
    // 仿微信进度条
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    myProgressView = [[UIProgressView alloc] initWithFrame:barFrame];
    myProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    myProgressView.progressTintColor = [UIColor redColor];
    [self.navigationController.navigationBar addSubview:myProgressView];
    
}
#pragma mark - 网页相关代理
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    myProgressView.progress = 0;
    theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideMessageAction];
    
    theBool = true;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showEmptyViewWithMessage:error.localizedDescription];
}
-(void)timerCallback {
    if (theBool) {
        if (myProgressView.progress >= 1) {
            myProgressView.hidden = true;
            [myTimer invalidate];
        }
        else {
            myProgressView.progress += 0.1;
        }
    }
    else {
        myProgressView.progress += 0.05;
        if (myProgressView.progress >= 0.8) {
            myProgressView.progress = 0.8;
        }
    }
}



@end


