//
//  AppearHeadView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/31.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AppearHeadView.h"

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
    UIImageView *topImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sy_bg"]];
    topImageV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    [self addSubview:topImageV];
    
    
}

@end
