//
//  YLZGTitleLabel.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "YLZGTitleLabel.h"


@interface YLZGTitleLabel ()


@end

@implementation YLZGTitleLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        self.userInteractionEnabled = YES;
        self.scale = 0.0;
        
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    self.textColor = [UIColor colorWithRed:0 green:0 blue:scale alpha:1.0]; // scale = 0.···;
    CGFloat minScale = 0.75;// RGBACOLOR(31, 139, 229, 1)
    CGFloat trueScale = minScale + (1 - minScale) * scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
    
}



@end
