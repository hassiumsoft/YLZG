//
//  QIaodaoBeizhuView.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QIaodaoBeizhuView : UIView 

// 黑色背景
@property (nonatomic, strong) UIImageView * whiteView;

// 第一行字(外勤签到备注)
@property (nonatomic, strong) UILabel * topLabel;

// 打卡时间
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * timeText;

// 打卡地点
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UILabel * addressText;

// 打卡备注
@property (nonatomic, strong) UITextView * beizhuView;

//// 接收地址字典
//@property (nonatomic, strong) NSMutableDictionary * addressDict;

+ (instancetype)sharedBeizhuView;

@end
