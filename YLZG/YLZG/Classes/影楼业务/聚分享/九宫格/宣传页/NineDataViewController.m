//
//  NineDataViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2017/1/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "NineDataViewController.h"
#import "NormalIconView.h"
#import <Masonry.h>

@interface NineDataViewController ()

@property (strong,nonatomic) NormalIconView *emptyBtn;

@end

@implementation NineDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"九宫格数据统计";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadEmptyView:@"您可以在每个九宫格里查看统计详情"];
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
    self.emptyBtn.iconView.image = [UIImage imageNamed:@"happyness"];
    self.emptyBtn.label.text = message;
    self.emptyBtn.label.numberOfLines = 0;
    self.emptyBtn.label.textColor = RGBACOLOR(219, 99, 155, 1);
    self.emptyBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.emptyBtn];
    
    [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
        make.height.equalTo(@45);
    }];
}



@end
