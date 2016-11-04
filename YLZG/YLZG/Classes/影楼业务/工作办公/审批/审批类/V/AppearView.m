//
//  AppearView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/1.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AppearView.h"
#import <Masonry.h>


@interface AppearView ()



@end

@implementation AppearView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *numLabel = [[UILabel alloc]init];
    numLabel.text = @"0";
    numLabel.font = [UIFont boldSystemFontOfSize:20];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.layer.masksToBounds = YES;
    numLabel.layer.cornerRadius = 4;
    numLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;;
    numLabel.layer.borderWidth = 1;
    [self addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-10);
        make.width.and.height.equalTo(@(50*CKproportion));
    }];
    self.numLabel = numLabel;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"待我审批";
    titleLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(numLabel.mas_bottom).offset(3);
        make.height.equalTo(@21);
    }];
    self.titleLabel = titleLabel;
    
}

@end
