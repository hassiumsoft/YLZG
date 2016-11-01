//
//  MoreToolButton.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/25.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MoreToolButton.h"
#import <Masonry.h>


@interface MoreToolButton ()

@property (copy,nonatomic) NSString *iconName;

@property (copy,nonatomic) NSString *titleStr;

@end

@implementation MoreToolButton

- (instancetype)initWithFrame:(CGRect)frame Icon:(NSString *)icon Title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        // 白色底部
        UIView *whiteView = [[UIView alloc]init];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius = 8;
        [self addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(-5);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(@55);
            make.height.equalTo(@54);
        }];
        
        // icon
        UIImageView *iconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:icon]];
        [whiteView addSubview:iconV];
        [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(whiteView.mas_centerY);
            make.centerX.equalTo(whiteView.mas_centerX);
            make.left.equalTo(whiteView.mas_left).offset(8);
            make.top.equalTo(whiteView.mas_top).offset(8);
        }];
        
        // 标题
        UILabel *label = [[UILabel alloc]init];
        label.text = title;
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        label.textColor = RGBACOLOR(52, 71, 94, 1);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(whiteView.mas_bottom);
            make.height.equalTo(@21);
        }];
    }
    return self;
}


@end
