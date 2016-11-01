//
//  QIaodaoBeizhuView.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "QIaodaoBeizhuView.h"
#import <Masonry.h>
#define PlaceText @"填写打卡备注(选填)"

@interface QIaodaoBeizhuView ()<UITextViewDelegate>

@end

@implementation QIaodaoBeizhuView

static QIaodaoBeizhuView * _instance;
+ (instancetype)sharedBeizhuView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
        self.alpha = 1;
    }
    return self;
}

- (void)createView {
    self.backgroundColor = RGBACOLOR(79, 79, 109, 0.8);
    UIImage * image = [UIImage imageNamed:@"qiandaobeizhu_image"];
    self.whiteView = [[UIImageView alloc] init];
    self.whiteView.image = image;
    [self addSubview:self.whiteView];
    self.whiteView.userInteractionEnabled = YES;
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-30);
        make.width.equalTo(@(image.size.width));
        make.height.equalTo(@(image.size.height));
    }];
   
    // 第一行
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.textColor = [UIColor blackColor];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteView.mas_centerX);
        make.top.equalTo(self.whiteView.mas_top).equalTo(@20);
        make.height.equalTo(@20);
        make.width.equalTo(self.whiteView.mas_width);
    }];
    
    // 第二行
    UIView * grayView = [[UIView alloc] init];
    grayView.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    [self.whiteView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView.mas_left);
        make.top.equalTo(self.topLabel.mas_bottom).equalTo(@20);
        make.width.equalTo(self.whiteView.mas_width);
        make.height.equalTo(@100);
    }];
    
    // 打卡时间
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.text = @"打卡时间 :";
    self.timeLabel.textColor = RGBACOLOR(124, 124, 124, 1);
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [grayView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayView.mas_left).equalTo(@10);
        make.top.equalTo(grayView.mas_top).equalTo(@10);
        make.height.equalTo(@20);
    }];
    
    self.timeText = [[UILabel alloc] init];
    self.timeText.text = [self getCurrentTime];
    self.timeText.font = [UIFont systemFontOfSize:14];
    self.timeText.textAlignment = NSTextAlignmentLeft;
    [grayView addSubview:self.timeText];
    [self.timeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).equalTo(@10);
        make.top.equalTo(self.timeLabel.mas_top);
        make.height.equalTo(@20);
    }];
    
    // 打卡地点
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.text = @"打卡地点 :";
    self.addressLabel.textColor = RGBACOLOR(124, 124, 124, 1);
    self.addressLabel.font = [UIFont systemFontOfSize:14];
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    [grayView addSubview:self.addressLabel];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayView.mas_left).equalTo(@10);
        make.top.equalTo(self.timeLabel.mas_bottom).equalTo(@10);
        make.height.equalTo(@20);
    }];
    
    self.addressText = [[UILabel alloc] init];
    self.addressText.font = [UIFont systemFontOfSize:14];
    self.addressText.numberOfLines = 0;
    self.addressText.textAlignment = NSTextAlignmentLeft;
    [grayView addSubview:self.addressText];
    [self.addressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLabel.mas_right).equalTo(@10);
        make.top.equalTo(self.timeText.mas_bottom).equalTo(@-10);
        make.height.equalTo(@60);
        make.width.equalTo(@200);
    }];
    
    // 打卡备注
    self.beizhuView = [[UITextView alloc] init];
    self.beizhuView.text = PlaceText;
    self.beizhuView.textColor = [UIColor lightGrayColor];
    self.beizhuView.delegate = self;
    [self.whiteView addSubview:self.beizhuView];
    
    
    
    // 最后两个按钮
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"暂不打卡"forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:RGBACOLOR(43, 153, 232, 1) forState:UIControlStateNormal];
    button.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    button.tag = 10;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.whiteView.mas_bottom);
        make.width.equalTo(@(image.size.width/2));
        make.left.equalTo(self.whiteView.mas_left);
        make.height.equalTo(@44);
    }];
    
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor grayColor];
    [self.whiteView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_right);
        make.width.equalTo(@0.8);
        make.height.equalTo(@44);
        make.bottom.equalTo(self.whiteView.mas_bottom);
    }];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.tag = 11;
    [button1 setTitle:@"立即打卡"forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:15];
    [button1 setTitleColor:RGBACOLOR(43, 153, 232, 1) forState:UIControlStateNormal];
    button1.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    [button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.whiteView.mas_bottom);
        make.width.equalTo(@(image.size.width/2-0.8));
        make.left.equalTo(lineLabel.mas_right);
        make.height.equalTo(@44);
    }];
    
    // 备注的位置
    [self.beizhuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(grayView.mas_bottom);
        make.left.equalTo(self.whiteView.mas_left);
        make.width.equalTo(self.whiteView.mas_width);
        make.bottom.equalTo(button.mas_top);
    }];
}

#pragma mark -button的点击事件相关
- (void)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 10:
        {
            [self removeFromSuperview];
        }
            break;
        case 11:
        {
            [self removeFromSuperview];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dakaTime" object:self.beizhuView.text ];
        }
            break;
            
        default:
            break;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.beizhuView.text isEqualToString:PlaceText]) {
        self.beizhuView.text = @"";
        self.beizhuView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.beizhuView.text isEqualToString:@""]) {
        self.beizhuView.text = PlaceText;
        self.beizhuView.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark -当前时间
- (NSString *)getCurrentTime {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString * returnStr = [formatter stringFromDate:[NSDate date]];
    return returnStr;
}

@end
