//
//  WXShareView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/28.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "WXShareView.h"
#import <Masonry.h>
#import "NormalIconView.h"



@implementation WXShareView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 猛图
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = CoverColor;
    [button addTarget:self action:@selector(removeSubViews) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
    [self addSubview:button];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70, SCREEN_WIDTH, 70)];
    backView.backgroundColor = NorMalBackGroudColor;
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    
    // 分享按钮
    NSArray *titleArray = [NSArray arrayWithObjects:@"朋友圈",@"微信好友",nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"cm2_blogo_pyq",@"cm2_blogo_weixin",nil];
    CGFloat spaceH = 1; // 横向间距
    CGFloat W = (SCREEN_WIDTH - spaceH*6)/4;  // 宽
    for (int i = 0; i < titleArray.count; i++) {
        CGRect frame;
        frame.size.width = W;
        frame.size.height = 70;
        frame.origin.x = (i%4) * (frame.size.width + spaceH) + spaceH;
        frame.origin.y = 3;
        NormalIconView *button = [NormalIconView sharedHomeIconView]; // 64
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 20 + i;
        button.label.text = titleArray[i];
        button.iconView.image = [UIImage imageNamed:imageArray[i]];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:frame];
        [backView addSubview:button];
        
    }
    
}

- (void)buttonClick:(UIButton *)sender
{
    
}

- (void)removeSubViews
{
    [self removeFromSuperview];
}
@end
