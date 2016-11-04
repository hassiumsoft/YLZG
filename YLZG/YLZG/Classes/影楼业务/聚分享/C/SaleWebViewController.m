//
//  SaleWebViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/3.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SaleWebViewController.h"
#import "ZCAccountTool.h"
#import "SaleToolModel.h"
#import <MJExtension.h>
#import "NormalIconView.h"
#import "HTTPManager.h"
#import <Masonry.h>

@interface SaleWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (strong,nonatomic) SaleToolModel *model;

@property (strong,nonatomic) UIWebView *webView;

@property (strong,nonatomic) NormalIconView *emptyBtn;

@end

@implementation SaleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
}
- (void)getData
{
    NSString *url = [NSString stringWithFormat:YingxiaoToolDetial_URL,[ZCAccountTool account].userID,self.saleModel.id];
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            self.model = [SaleToolModel mj_objectWithKeyValues:result];
            [self setupSubViews:self.model];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self loadEmptyView:error.localizedDescription];
    }];
}

- (void)setupSubViews:(SaleToolModel *)model
{
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.content]]];
    self.webView.scrollView.delegate = self;
    self.webView.userInteractionEnabled=YES;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.webView.scalesPageToFit = YES;
    self.webView.multipleTouchEnabled = YES;
    
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView reload];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self loadEmptyView:error.localizedDescription];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    KGLog(@"pointX = %f,pointY = %f",point.x,point.y);
}


#pragma mark - 没有数据时
- (void)loadEmptyView:(NSString *)message
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    // 全部为空值
    self.emptyBtn = [NormalIconView sharedHomeIconView];
    self.emptyBtn.iconView.image = [UIImage imageNamed:@"sadness"];
    self.emptyBtn.label.text = message;
    self.emptyBtn.label.numberOfLines = 0;
    self.emptyBtn.label.textColor = RGBACOLOR(219, 99, 155, 1);
    self.emptyBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.emptyBtn];
    
    
    [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
}



@end
