//
//  MonthPicerView.m
//  YLZG
//
//  Created by Chan_Sir on 2017/3/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "MonthPicerView.h"


@interface MonthPicerView ()

@property (strong,nonatomic) UIDatePicker *datePicker;

@property (strong,nonatomic) UIButton *mengButton;


@end

#define PickerHeight 180
#define ChooseHeight 40


@implementation MonthPicerView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setupSubViews:frame];
    }
    return self;
}

- (void)setupSubViews:(CGRect)frame
{
    // mengButton
    self.mengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mengButton.backgroundColor = RGBACOLOR(10, 10, 10, 0.1);
    __weak MonthPicerView *copySelf = self;
    [self.mengButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [copySelf removeSubViews];
    }];
    self.mengButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - PickerHeight - ChooseHeight);
    [self addSubview:self.mengButton];
    
    // 中间的条
    UIView *chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mengButton.height, self.width, ChooseHeight)];
    chooseView.userInteractionEnabled = YES;
    chooseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:chooseView];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(10, 0, 70, chooseView.height);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [cancleBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [copySelf removeSubViews];
    }];
    [chooseView addSubview:cancleBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(self.width - 10 - 70, 0, 70, chooseView.height);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [confirmBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSString *dateStr = [NSString stringWithFormat:@"%@",self.datePicker.date];
        if (dateStr.length < 7) {
            return ;
        }
        dateStr = [dateStr substringWithRange:NSMakeRange(0, 7)];
        if (self.SelectDateBlock) {
            _SelectDateBlock(dateStr);
            [copySelf removeSubViews];
        }
    }];
    [chooseView addSubview:confirmBtn];
    
    // 选择日期
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, frame.size.height - PickerHeight, self.width, PickerHeight)];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate *date = [NSDate date];
    [self.datePicker setMaximumDate:date];
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [self addSubview:self.datePicker];
    
    
}


- (void)removeSubViews
{
    [self removeFromSuperview];
}




@end
