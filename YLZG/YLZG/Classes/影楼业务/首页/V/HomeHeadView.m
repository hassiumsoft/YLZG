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

@property (strong,nonatomic) UIButton *tipsButton;

@end

@implementation HomeHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.imageV];
        [self.imageV addSubview:self.tipsButton];
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

- (UIButton *)tipsButton
{
    if (!_tipsButton) {
        _tipsButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 23, 36, 36)];
        [_tipsButton setImage:[UIImage imageNamed:@"btn_gonggao"] forState:UIControlStateNormal];
        [_tipsButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipsButton;
}

- (void)click
{
    if (_ClickBlock) {
        _ClickBlock();
    }
}

@end
