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
#import "NewFutherModel.h"
#import <MJExtension.h>



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
            NSArray *tempArr = [responseObject objectForKey:@"result"];
            self.imaArray = [NewFutherModel mj_objectArrayWithKeyValuesArray:tempArr];
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
    for (NewFutherModel *model in images) {
        NSURL *url = [NSURL URLWithString:model.url];
        [array addObject:url];
    }
    if (array.count == 1) {
        [array removeAllObjects];
    }
    // 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.view.bounds imageURLsGroup:array];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    [self.view addSubview:cycleScrollView];
    
    
    // 立即体验
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new_futher_btn"]];
    imageV.userInteractionEnabled = YES;
    [self.view addSubview:imageV];
    if (array.count == 1 || array.count == 0) {
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom).offset(-15);
            make.height.equalTo(@35);
            make.left.equalTo(self.view.mas_left).offset(100*CKproportion);
        }];
    }else{
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.bottom.equalTo(self.view.mas_bottom).offset(-45);
            make.height.equalTo(@35);
            make.left.equalTo(self.view.mas_left).offset(100*CKproportion);
        }];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self buttonClick];
    }];
    [imageV addGestureRecognizer:tap];
}
- (void)buttonClick
{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
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
