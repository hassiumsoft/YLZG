//
//  NineReusableView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/2.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NineReusableView.h"


@interface NineReusableView ()

@property (strong,nonatomic) UILabel *titleLabel;

@end

@implementation NineReusableView


- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 120, 40)];
    self.titleLabel.text = @"推荐模板";
    self.titleLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.titleLabel];
    
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 4)];
    bottomV.backgroundColor = NorMalBackGroudColor;
    [self addSubview:bottomV];
    
    UIImageView *rightIconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_gg_chakan"]];
    [self addSubview:rightIconV];
    [rightIconV setFrame:CGRectMake(SCREEN_WIDTH - 35, 10, 30, 20)];
    [self addSubview:rightIconV];
    
}


@end
