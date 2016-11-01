//
//  NavigationView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/31.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NavigationView.h"
#import <Masonry.h>

@interface NavigationView ()



@end

@implementation NavigationView

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
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"我的影楼";
    self.titleLabel.textColor = RGBACOLOR(255, 255, 255, 0);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX); // 21 + 11
        make.top.equalTo(self.mas_top).offset(33);
        make.height.equalTo(@21);
    }];
    
}

@end
