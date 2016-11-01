//
//  NormalconButton.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NormalconButton.h"
#import <Masonry.h>


@interface NormalconButton ()

@property (strong,nonatomic) UILabel *numLabel;

@end


@implementation NormalconButton

+ (instancetype)sharedHomeIconView
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MainColor;
        [self setupSubViews];
        
    }
    return self;
}
- (void)setCount:(NSInteger)count
{
    _count = count;
    if (count >= 1) {
        _numLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
        [_numLabel setHidden:NO];
    }else{
        [_numLabel setHidden:YES];
    }
}

- (void)setupSubViews
{
    self.iconView = [[UIImageView alloc]init];
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-5);
        make.width.equalTo(@42);
        make.height.equalTo(@42);
    }];
    
    self.label = [[UILabel alloc]init];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.label.textColor = [UIColor whiteColor];
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(2);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@20);
    }];
    
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.numLabel.text = [NSString stringWithFormat:@"%ld",(long)_count];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.numLabel.textColor = [UIColor whiteColor];
    self.numLabel.userInteractionEnabled = YES;
    self.numLabel.layer.masksToBounds = YES;
    self.numLabel.backgroundColor = RGBACOLOR(237, 25, 25, 1);
    self.numLabel.layer.cornerRadius = 11;
    [self addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(-10);
        make.top.equalTo(self.iconView.mas_top).offset(-6);
        make.width.and.height.equalTo(@22);
    }];
    
}

@end
