//
//  TitleLabel.m
//  StudioHD
//
//  Created by Chan_Sir on 16/8/11.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TitleLabel.h"

@implementation TitleLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont boldSystemFontOfSize:24];
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8.f;
        self.backgroundColor = [UIColor whiteColor];
        self.scale = 0.0;
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    self.textColor = [UIColor colorWithRed:scale green:0.23f blue:0.67f alpha:1.0];
    CGFloat minScale = 0.7;
    CGFloat trueScale = minScale + (1 - minScale) * scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}


@end
