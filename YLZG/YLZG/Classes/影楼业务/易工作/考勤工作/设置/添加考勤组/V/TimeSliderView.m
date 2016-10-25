//
//  TimeSliderView.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/26.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TimeSliderView.h"
#import <Masonry.h>

@interface TimeSliderView ()

@property (strong,nonatomic) UISlider *slider;

@property (strong,nonatomic) UILabel *timeLabel;

@end

@implementation TimeSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    
    
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@40);
    }];
    
    
    [self addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.timeLabel.mas_bottom);
        make.left.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    
}

- (void)sliderClick:(UISlider *)slider
{
    self.timeLabel.text = [NSString stringWithFormat:@"%d分钟",(int)slider.value];
    
    
}

- (void)removeFromSuperview
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timeTypeKey"] = self.timeTypeKey;
    dict[@"timeTypeValue"] = [NSString stringWithFormat:@"%d",(int)self.slider.value];
    
    [YLNotificationCenter postNotificationName:KaoqinSettingNoti object:nil userInfo:dict];
    
    [super removeFromSuperview];
}
- (void)addTarget:(id)target Action:(SEL)action
{
    
}
- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc]init];
        _slider.minimumValue = 0;
        _slider.maximumValue = 180;
        _slider.thumbTintColor = MainColor;
        [_slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"0";
        _timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

@end
