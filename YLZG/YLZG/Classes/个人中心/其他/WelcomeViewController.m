//
//  WelcomeViewController.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/27.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "WelcomeViewController.h"
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "HTTPManager.h"
#import "ZCAccountTool.h"


@interface WelcomeViewController ()<UIScrollViewDelegate>

@property (copy,nonatomic) NSArray *imageArray;

@property (strong,nonatomic) UIScrollView *sc;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)getData {
    
    [HTTPManager GET:LeadPage_Url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSArray * resultArr = responseObject[@"result"];
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dd in resultArr) {
                [arr addObject:dd[@"url"]];
            }
            
            self.imageArray = arr;
            // 加载引导页
            [self createGiudePage];
        }else{
            [self showErrorTips:message];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorTips:error.localizedDescription];
    }];
    
//    [AFHTTPSessionManager GETOder:[NSString stringWithFormat:LeadPage_Url,account.userID] parameter:nil success:^(id responseObject) {
//        NSError * error;
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
//        if (error) {
//            // 解析失败
//            [SVProgressHUD showErrorWithStatus:@"解析失败"];
//        }else {
//            
//            int status = [[[dic objectForKey:@"code"] description] intValue];
//            if (status == 1) {
//                NSArray * resultArr = dic[@"result"];
//                NSMutableArray * arr = [NSMutableArray array];
//                for (NSDictionary * dd in resultArr) {
//                    [arr addObject:dd[@"url"]];
//                }
//                
//                self.imageArray = arr;
//                // 加载引导页
//                [self createGiudePage];
//                
//            }else {
//                [SVProgressHUD showErrorWithStatus:@"暂无引导页"];
//            }
//        }
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//    }];
}

#pragma mark -加载引导页
- (void)createGiudePage {
    _sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _sc.delegate = self;
    _sc.alwaysBounceHorizontal = YES;
    _sc.alwaysBounceVertical = NO;
    _sc.bounces = NO;
    _sc.showsHorizontalScrollIndicator = NO;
    _sc.showsVerticalScrollIndicator = NO;
    _sc.pagingEnabled = YES;
    
    // 加载图片
    _sc.contentSize = CGSizeMake(SCREEN_WIDTH * _imageArray.count, SCREEN_HEIGHT);
    for (int i = 0; i < _imageArray.count; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i]]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [_sc addSubview:imageView];
        
        // 判断最后一张图片,加跳转按钮
        if (i == _imageArray.count - 1) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
            tap.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:tap];
        }
    }
    [self.view addSubview:_sc];
}
- (void)removeSelf
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:CFBundleVersion];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (SCREEN_WIDTH == 375) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cm2_fm_bg-ip6"]];
    }else{
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"check_box_bg"]];
    }
    
    [self getData];
//    [self.navigationController.navigationBar setHidden:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setHidden:NO];
}

@end
