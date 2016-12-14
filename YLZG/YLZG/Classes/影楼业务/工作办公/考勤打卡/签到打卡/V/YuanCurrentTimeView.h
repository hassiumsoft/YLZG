//
//  YuanCurrentTimeView.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QIaodaoBeizhuView.h"

typedef void(^YuanQiuView)(void);

@interface YuanCurrentTimeView : UIView
{
    NSTimer * timer;
}

@property (nonatomic, copy) YuanQiuView yuanClick;
// 底部的图片
@property (nonatomic, strong)UIImageView * imageView;
// 第一行文字
@property (nonatomic, strong) UILabel * firstLabel;
// 第二行文字
@property (nonatomic, strong) UILabel * timeLabel;

// 点击按钮跳转的页面
@property (nonatomic, strong) QIaodaoBeizhuView * beizhuView;

@end
