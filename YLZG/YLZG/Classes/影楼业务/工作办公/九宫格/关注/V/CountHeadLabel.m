//
//  CountHeadLabel.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/7.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CountHeadLabel.h"


@interface CountHeadLabel ()

@property (strong,nonatomic) UILabel *titleLabel;

@property (strong,nonatomic) UILabel *numLabel;

@end

@implementation CountHeadLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleLabel.text = titleStr;
}
- (void)setNumberStr:(NSString *)numberStr
{
    _numLabel.text = numberStr;
}

- (void)setupSubViews
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 35)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = RGBACOLOR(26, 26, 26, 1);
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.titleLabel];
    
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH/3, 40)];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.textColor = RGBACOLOR(26, 26, 26, 1);
    self.numLabel.font = [UIFont boldSystemFontOfSize:21];
    [self addSubview:self.numLabel];
    
    
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 5)];
    bottom.backgroundColor = NorMalBackGroudColor;
    [self addSubview:bottom];
    
}

@end
