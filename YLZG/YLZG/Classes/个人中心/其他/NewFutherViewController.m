//
//  NewFutherViewController.m
//  YLZG
//
//  Created by Chan_Sir on 16/8/31.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "NewFutherViewController.h"
#import "ZCAccountTool.h"
#import <Masonry.h>
#import "SDCycleScrollView.h"
#import "AppDelegate.h"
#import "HTTPManager.h"



@interface NewFutherViewController ()

@property (strong,nonatomic) NSMutableArray *imaArray;

@end

@implementation NewFutherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"欢迎栏";
    
    if (SCREEN_WIDTH == 375) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"langh_bg_ip6"]];
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"langh_bg"]];
    }
    
    
    [self getData];
    
}

- (void)getData {
    ZCAccount * account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:LeadPage_Url,account.userID];
    
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *dictionary = [responseObject objectForKey:@"result"];
            KGLog(@"dictionary = %@",dictionary);
            NSArray * resultArr = dictionary[@"result"];
            for (NSDictionary * dd in resultArr) {
                [self.imaArray addObject:dd[@"url"]];
            }
            [self setupSubViews:self.imaArray];
        }else{
            [self showErrorTips:message];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
    

}
- (void)setupSubViews:(NSMutableArray *)images
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in images) {
        NSURL *url = [NSURL URLWithString:str];
        [array addObject:url];
    }
    
    // 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.view.bounds imageURLsGroup:array];
//    cycleScrollView.delegate = self;
//    cycleScrollView.titlesGroup = @[@"1",@"2",@"3",@"4"];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    [self.view addSubview:cycleScrollView];
    
    
    // 立即体验
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [button setTitleColor:WeChatColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 6;
    button.layer.borderColor = WeChatColor.CGColor;
    button.layer.borderWidth = 1.f;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.height.equalTo(@35);
        make.left.equalTo(self.view.mas_left).offset(100*CKproportion);
    }];
}
- (void)buttonClick
{
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.isShowNewPage = NO;
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (NSMutableArray *)imaArray
{
    if (!_imaArray) {
        _imaArray = [[NSMutableArray alloc]init];
    }
    return _imaArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

@end
