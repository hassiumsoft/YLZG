//
//  TopTitleView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TopTitleView.h"

@interface TopTitleView ()

@property (strong,nonatomic) UILabel *titleLabel;

@property (strong,nonatomic) UIView *xianView;

@end

@implementation TopTitleView

- (void)setIsCurrentIndex:(BOOL)isCurrentIndex
{
    _isCurrentIndex = isCurrentIndex;
    if (isCurrentIndex) {
        _titleLabel.textColor = MainColor;
        _xianView.hidden = NO;
    }else{
        _titleLabel.textColor = RGBACOLOR(20, 20, 20, 1);
        _xianView.hidden = YES;
    }
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = NorMalBackGroudColor;
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - 3)];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = RGBACOLOR(20, 20, 20, 1);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.xianView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 3, self.width, 3)];
    self.xianView.backgroundColor = MainColor;
    [self addSubview:self.xianView];
}


@end
