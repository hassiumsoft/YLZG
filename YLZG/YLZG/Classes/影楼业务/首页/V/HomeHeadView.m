//
//  HomeHeadView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HomeHeadView.h"


@interface HomeHeadView ()

@property (strong,nonatomic) UIImageView *imageV;

@end

@implementation HomeHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.imageV];
    }
    return self;
}

- (UIImageView *)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sy_bg"]];
        _imageV.userInteractionEnabled = YES;
        _imageV.frame = self.bounds;
    }
    return _imageV;
}

@end
