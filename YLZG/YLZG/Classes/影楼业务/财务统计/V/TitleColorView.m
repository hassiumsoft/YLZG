//
//  TitleColorView.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/5.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "TitleColorView.h"
#import <Masonry.h>

#define myWidth (SCREEN_WIDTH - 2.5)/4

@interface TitleColorView ()

@property (strong,nonatomic) UIView *colorV;

@property (strong,nonatomic) UILabel *label;

@end

@implementation TitleColorView

- (instancetype)initWithFrame:(CGRect)frame Color:(UIColor *)color Title:(NSString *)title
{
    TitleColorView *colorV = [[TitleColorView alloc]initWithFrame:frame];
    colorV.userInteractionEnabled = YES;
    self.colorV.backgroundColor = color;
    [colorV addSubview:self.colorV];
    self.label.text = title;
    
    [colorV addSubview:self.label];
    
    return colorV;
}

- (UIView *)colorV
{
    if (!_colorV) {
        _colorV = [[UIView alloc]initWithFrame:CGRectMake((myWidth - 30*CKproportion)/2, 5, 30 * CKproportion, 30 * CKproportion)];
        _colorV.userInteractionEnabled = YES;
        _colorV.layer.cornerRadius = 15*CKproportion;
    }
    return _colorV;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 34*CKproportion, myWidth, 21*CKproportion)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:9];
        
    }
    return _label;
}


@end
