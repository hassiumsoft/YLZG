//
//  TitleColorDescView.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/29.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "TitleColorDescView.h"
#import <Masonry.h>

@implementation TitleColorDescView

+ (instancetype)sharedTitleColorDescView
{
    return [[self alloc]init];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.colorView = [[UIView alloc]init];
    self.colorView.backgroundColor = [UIColor purpleColor];
    self.colorView.layer.masksToBounds = YES;
    self.colorView.layer.cornerRadius = 10*CKproportion;
    [self addSubview:self.colorView];
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(5);
        make.width.and.height.equalTo(@(20*CKproportion));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"摄影二次销售";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont italicSystemFontOfSize:14*CKproportion];
    [self.titleLabel sizeToFit];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.colorView.mas_right).offset(5);
        make.height.equalTo(@21);
    }];
}

@end
