//
//  QiaodaoCountButton.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "QiaodaoCountButton.h"
#import <Masonry.h>

@implementation QiaodaoCountButton

+ (instancetype)shareqiaodaocountBtn {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = RGBACOLOR(10, 10, 10, 1);
    self.label.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@21);
    }];
    self.leftImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"change_calender"]];
    [self addSubview:self.leftImageV];
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.label.mas_left).offset(-5);
        make.width.equalTo(@22);
        make.width.equalTo(@28);
    }];
    self.rightImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down_menu"]];
    [self addSubview:self.rightImageV];
    [self.rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.label.mas_right).offset(3);
        make.width.equalTo(@22);
        make.height.equalTo(@28);
    }];
}


@end
