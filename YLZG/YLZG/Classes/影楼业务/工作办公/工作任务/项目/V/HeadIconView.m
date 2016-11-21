//
//  HeadIconView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/18.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HeadIconView.h"
#import <UIImageView+WebCache.h>


@interface HeadIconView ()

@property (strong,nonatomic) UIImageView *imageV;

@property (strong,nonatomic) UILabel *nameLabel;

@end

@implementation HeadIconView

- (void)setModel:(ContactersModel *)model
{
    _model = model;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
    _nameLabel.text = model.realname;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.imageV = [[UIImageView alloc]initWithFrame:self.bounds];
    self.imageV.layer.masksToBounds = YES;
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageV];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-20, self.width, 20)];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.backgroundColor = RGBACOLOR(109, 109, 109, 0.8);
    [self addSubview:self.nameLabel];
}

@end
