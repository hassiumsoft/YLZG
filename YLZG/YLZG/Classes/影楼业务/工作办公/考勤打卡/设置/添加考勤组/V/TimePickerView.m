//
//  TimePickerView.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/6/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TimePickerView.h"
#import <Masonry.h>

@interface TimePickerView ()

@property (strong,nonatomic) UIDatePicker *datePicker;


@end


@implementation TimePickerView


- (instancetype)initWithFrame:(CGRect)frame DateTimeMode:(NSInteger)pickerMode
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}






+ (instancetype)sharedTimePickerView
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setUpsunViews];
    }
    return self;
}

- (void)setUpsunViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.datePicker = [[UIDatePicker alloc]init];
    NSDate *date = [NSDate date];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    self.datePicker.timeZone = timeZone;
//    NSInteger seconds = [timeZone secondsFromGMTForDate:date];
//    NSDate *newDate = [date dateByAddingTimeInterval:seconds];
    [self.datePicker setDate:date animated:YES];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    [self addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@180);
    }];
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = MainColor;
    topView.userInteractionEnabled = YES;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.datePicker.mas_top);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@40);
        make.left.equalTo(self.mas_left);
    }];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(10, 6, 40, 24);
    leftBtn.tag = 66;
    [leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 67;
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH-50, 6, 40, 24);
    [rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:rightBtn];
    
}

- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 66:
        {
            
            [self removeFromSuperview];
            break;
        }
        case 67:
        {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
            NSTimeZone *timeZone = [NSTimeZone systemTimeZone]; // 上海时区
            NSInteger seconds = [timeZone secondsFromGMTForDate:self.datePicker.date];
            NSDate *newDate = [self.datePicker.date dateByAddingTimeInterval:seconds];
            NSString *str = [NSString stringWithFormat:@"%@",newDate];
            
            // 东八区的时间
            NSString *realTime = [str substringWithRange:NSMakeRange(11, 5)];
            if (self.timeType == StartTime) {
                // 发出上班时间通知
                [YLNotificationCenter postNotificationName:StartWorkTime object:realTime];
            }else {
                //  发出下班时间通知
                [YLNotificationCenter postNotificationName:EndWorkTime object:realTime];
            }
            [self removeFromSuperview];
            break;
        }
        default:
            break;
    }
}

@end
