//
//  SCXDateTimePicker.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SCXDateTimePicker.h"
#import "UIView+Extension.h"

@interface SCXDateTimePicker ()

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIDatePicker * datePicker;

@end

@implementation SCXDateTimePicker

+ (instancetype)shareSCXDateTimePicker {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBACOLOR(79, 79, 100, 1);
        self.alpha = 0;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addTarget:self action:@selector(removeMyself:) forControlEvents:UIControlEventTouchUpInside];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 188)];
    _backView.alpha = 0.2;
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH, _backView.height-38)];
    self.datePicker.minuteInterval = 1;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [self.datePicker setDate:[NSDate date] animated:YES];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [_backView addSubview:self.datePicker];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
    topView.backgroundColor = RGBACOLOR(69, 86, 150, 1);
    topView.userInteractionEnabled = YES;
    [_backView addSubview:topView];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(10, 6, 40, 24);
    [leftBtn addTarget:self action:@selector(removeMyself:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH-50, 6, 40, 24);
    [rightBtn addTarget:self action:@selector(endPickClock:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:rightBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.y = SCREEN_HEIGHT-189;
        self.alpha = 0.9;
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 选择时间日期
- (void)endPickClock:(UIButton *)sender {

    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone]; // 上海时区
    NSInteger seconds = [timeZone secondsFromGMTForDate:self.datePicker.date];
    NSDate *newDate = [self.datePicker.date dateByAddingTimeInterval:seconds];
    NSString *str = [NSString stringWithFormat:@"%@",newDate];
    
    // 东八区的时间
    NSString *realTime = [str substringWithRange:NSMakeRange(0, 10)];
    
    
    // 传递给时间
    [YLNotificationCenter postNotificationName:YLQiaodaoTime object:realTime];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.y = SCREEN_HEIGHT;
        self.backView.alpha = 0.2;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [sender removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
    
}

- (void)removeMyself:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.y = SCREEN_HEIGHT;
        self.backView.alpha = 0.2;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [sender removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}

@end
