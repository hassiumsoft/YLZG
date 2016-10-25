//
//  YuanCurrentTimeView.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YuanCurrentTimeView.h"

@interface YuanCurrentTimeView ()

@end

@implementation YuanCurrentTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    self.imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    [self.imageView addGestureRecognizer:tap];
    
    self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, self.imageView.frame.size.width, 20)];
    self.firstLabel.textAlignment = NSTextAlignmentCenter;
    self.firstLabel.textColor = [UIColor whiteColor];
    self.firstLabel.font = [UIFont systemFontOfSize:14];
    [self.imageView addSubview:self.firstLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.firstLabel.frame)+5, self.imageView.frame.size.width, 20)];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    [self.imageView addSubview:self.timeLabel];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeFunc) userInfo:nil repeats:YES];
}

- (void)timeFunc {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString * timeStamp = [formatter stringFromDate:[NSDate date]];
    self.timeLabel.text = timeStamp;
}

- (void)tapClicked:(UITapGestureRecognizer *)tap {
    if (self.yuanClick) {
        self.yuanClick();
    }
    QIaodaoBeizhuView * hh = [QIaodaoBeizhuView sharedBeizhuView];
    hh.topLabel.text = self.firstLabel.text;
}



@end
