//
//  ChooseTimeView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ChooseTimeView.h"


#define PickerHeight 200

@interface ChooseTimeView ()

@property (strong,nonatomic) UIDatePicker *datePicker;

@property (strong,nonatomic) UIButton *coverBtn;


@end

@implementation ChooseTimeView

+ (instancetype)sharedChooseTimeView
{
    ChooseTimeView *copySelf = [[self alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    copySelf.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        copySelf.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    return copySelf;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.coverBtn];
    [self addSubview:self.datePicker];
    
    // 2个按钮
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_coverBtn.frame), SCREEN_WIDTH, 40)];
    topView.backgroundColor = MainColor;
    topView.userInteractionEnabled = YES;
    [self addSubview:topView];
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
    cancleBtn.backgroundColor = [UIColor clearColor];
    [cancleBtn addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [topView addSubview:cancleBtn];
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 0, 90, 40)];
    confirmBtn.backgroundColor = [UIColor clearColor];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [topView addSubview:confirmBtn];
    
}


- (UIButton *)coverBtn
{
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverBtn addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
        [_coverBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height - PickerHeight)];
        _coverBtn.backgroundColor = CoverColor;
        
    }
    return _coverBtn;
}
- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_coverBtn.frame) + 40, SCREEN_WIDTH, self.height - _coverBtn.height - 40)];
        UIColor *color = [[YLZGDataManager sharedManager] isSpringFestival] ? NormalColor : SpringColor;
        _datePicker.layer.borderColor = color.CGColor;
        _datePicker.layer.borderWidth = 1.f;
        _datePicker.datePickerMode = UIDatePickerModeTime;
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh"];
        
    }
    return _datePicker;
}
- (void)removeAction
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)confirmAction
{
    
    [self removeAction];
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone]; // 上海时区
    NSInteger seconds = [timeZone secondsFromGMTForDate:self.datePicker.date];
    NSDate *newDate = [self.datePicker.date dateByAddingTimeInterval:seconds];
    NSString *dateStr = [NSString stringWithFormat:@"%@",newDate];
    NSString *time = [dateStr substringWithRange:NSMakeRange(11, 5)];
    
    if (self.DidSelectTime) {
        _DidSelectTime(time);
    }
    
}

@end
