//
//  HomeReusableView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/28.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HomeReusableView.h"


@interface HomeReusableView ()

@property (strong,nonatomic) UILabel *titleLabel;

@end

@implementation HomeReusableView


- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor purpleColor];
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 120, 30)];
    self.titleLabel.text = @"财务统计";
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.titleLabel];
}

@end
