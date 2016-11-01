//
//  AppearHeadView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/31.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AppearHeadView.h"
#import "AppearView.h"


#define Height 150

@implementation AppearHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIImageView *topImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_bg"]];
    topImageV.frame = CGRectMake(0, 0, SCREEN_WIDTH, Height);
    [self addSubview:topImageV];
    
    // 添加view
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, Height, SCREEN_WIDTH, self.height-Height)];
    middleView.userInteractionEnabled = YES;
    [self addSubview:middleView];
    
    NSArray *titleArr = @[@"待我审批",@"我已审批",@"我发起的"];
    for (int i = 0; i < titleArr.count; i++) {
        CGRect frame;
        frame.origin.x = SCREEN_WIDTH/3 * i;
        frame.origin.y = Height;
        frame.size.width = SCREEN_WIDTH/3;
        frame.size.height = self.height - Height;
        AppearView *appearView = [[AppearView alloc]initWithFrame:frame];
        appearView.tag = 10+i;
        [self addSubview:appearView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ButtonClick:)];
        [appearView addGestureRecognizer:tap];
        
    }
    
}

- (void)ButtonClick:(UITapGestureRecognizer *)tap
{
    AppearView *view = (AppearView *)tap.view;
    
    if (_ClickBlock) {
        _ClickBlock(view.tag);
    }
}

@end
