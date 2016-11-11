//
//  FinaceIconView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "FinaceIconView.h"
#import <Masonry.h>


@interface FinaceIconView  ()

@property (strong,nonatomic) UIView *iconV;

@property (strong,nonatomic) UILabel *label;

@property (strong,nonatomic) UILabel *numLabel;

@end

@implementation FinaceIconView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setNum:(NSString *)num
{
    _num = num;
    _numLabel.text = num;
    
}
- (void)setColor:(UIColor *)color
{
    _color = color;
    _iconV.backgroundColor = color;
    _numLabel.textColor = color;
    _label.textColor = color;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    _label.text = title;
}


- (void)setupSubViews
{
    // 圆球
    self.iconV = [[UIView alloc]initWithFrame:CGRectMake(8, 1, 20, 20)];
    self.iconV.layer.masksToBounds = YES;
    self.iconV.layer.cornerRadius = 10;
    [self addSubview:self.iconV];
    
    // 名称
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconV.frame) + 5, 0, 50, 23)];
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    [self addSubview:self.label];
    
    // 值
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.label.frame)+5, 0, SCREEN_WIDTH/2 - 50 - 8 - 20, 23)];
    self.numLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    [self addSubview:self.numLabel];
    
}

@end
