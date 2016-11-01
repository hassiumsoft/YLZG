//
//  SubTitleView.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/4.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SubTitleView.h"
#import <Masonry.h>



@implementation SubTitleView

+ (SubTitleView *)sharedWithFrame:(CGRect)frame Week:(NSString *)week Date:(NSString *)date
{
    SubTitleView *subView = [[SubTitleView alloc]initWithFrame:frame];
    subView.backgroundColor = [UIColor whiteColor];
    
    UILabel *weekLabel = [[UILabel alloc]init];
    weekLabel.text = week;
//    weekLabel.font = [UIFont systemFontOfSize:14 * CKproportion];
    weekLabel.textAlignment = NSTextAlignmentCenter;
    [subView addSubview:weekLabel];
    [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(subView.mas_centerX);
        make.top.equalTo(subView.mas_top).offset(4);
        make.height.equalTo(@21);
    }];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.text = date;
//    dateLabel.font = [UIFont systemFontOfSize:11 * CKproportion];
    dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [subView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(subView.mas_centerX);
        make.top.equalTo(weekLabel.mas_bottom).offset(-2);
        make.height.equalTo(@21);
    }];
    
    return subView;
    
}

@end
