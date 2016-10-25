//
//  NoticeDetialView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NoticeDetialView.h"
#import <Masonry.h>

@implementation NoticeDetialView

+ (instancetype)sharedNoticeDetialView
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImageView *bottomV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gonggao_bg"]];
    bottomV.frame = self.bounds;
    [self addSubview:bottomV];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = self.model.title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(13);
        make.left.equalTo(self.mas_left).offset(30);
    }];
    
    
    UIView *xuxian = [[UIView alloc]init];
    xuxian.backgroundColor = [UIColor whiteColor];
    [xuxian setAlpha:0.5];
    [bottomV addSubview:xuxian];
    [xuxian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-40);
        make.left.equalTo(bottomV.mas_left).offset(5);
        make.right.equalTo(bottomV.mas_right).offset(-5);
        make.height.equalTo(@1);
    }];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    NSString *dateStr = [self timeIntervalToDate:self.model.create_time];
    dateLabel.text = dateStr;
    dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [bottomV addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xuxian.mas_bottom).offset(7);
        make.height.equalTo(@26);
        make.left.equalTo(bottomV.mas_left).offset(15);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    nameLabel.textColor = [UIColor grayColor];
    nameLabel.text = [NSString stringWithFormat:@"发布人：%@",self.model.realname];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [bottomV addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xuxian.mas_bottom).offset(7);
        make.height.equalTo(@26);
        make.right.equalTo(bottomV.mas_right).offset(-15);
    }];
    
    UIView *middleV = [[UIView alloc]init];
    middleV.userInteractionEnabled = YES;
    middleV.backgroundColor = [UIColor clearColor];
    [bottomV addSubview:middleV];
    [middleV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomV.mas_top).offset(60);
        make.left.equalTo(bottomV.mas_left);
        make.right.equalTo(bottomV.mas_right);
        make.bottom.equalTo(xuxian.mas_top).offset(-2);
    }];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.text = self.model.content;
    contentLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.numberOfLines = 0;
    [bottomV addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomV.mas_centerX);
        make.centerY.equalTo(bottomV.mas_centerY);
        make.left.equalTo(bottomV.mas_left).offset(15);
    }];
    
    
}

- (NSString *)timeIntervalToDate:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *origanStr = [NSString stringWithFormat:@"%@",date];
    NSString *time = [origanStr substringWithRange:NSMakeRange(0, 16)];
    return time;
}




@end
