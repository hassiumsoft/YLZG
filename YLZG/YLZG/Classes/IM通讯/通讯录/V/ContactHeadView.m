//
//  ContactHeadView.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ContactHeadView.h"
#import <Masonry.h>

@implementation ContactHeadView

+ (instancetype)sharedContactHeadView
{
    return [self new];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    self.jiantouV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"contact_jiantou_right"]];
    [self addSubview:self.jiantouV];
    [self.jiantouV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(8);
        make.width.and.height.equalTo(@18);
    }];
    
    self.deptLabel = [[UILabel alloc]init];
    self.deptLabel.text = @"部门名称";
    self.deptLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.deptLabel.textColor = [UIColor blackColor];
    [self addSubview:self.deptLabel];
    [self.deptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.jiantouV.mas_right).offset(5);
        make.height.equalTo(@30);
    }];
    
    self.memNumLabel = [[UILabel alloc]init];
    self.memNumLabel.textColor = [UIColor lightGrayColor];
    self.memNumLabel.font = [UIFont systemFontOfSize:9];
    self.memNumLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.memNumLabel];
    [self.memNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@21);
    }];
}
@end
