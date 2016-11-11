//
//  HuangzhuangBingTu.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HuangzhuangBingTu.h"
#import "NormalIconView.h"
#import <Masonry.h>

#define space 0
@implementation HuangzhuangBingTu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 分弧段
    
    CGFloat depositeNum = [self.model.deposit floatValue] / [self.model.income floatValue];
    CGFloat extraNum = [self.model.extra floatValue] / [self.model.income floatValue];
    CGFloat tsellNum = [self.model.tsell floatValue] / [self.model.income floatValue];
    CGFloat otherNum = [self.model.other floatValue] / [self.model.income floatValue];
    
    [self drawPathUseRed:233 green:73 blue:37 andStartAngle:0 endAngle:2*M_PI*depositeNum];
    [self drawPathUseRed:119 green:223 blue:255 andStartAngle:2*M_PI*(depositeNum + space) endAngle:2*M_PI*(depositeNum + space * 1 + extraNum)];
    [self drawPathUseRed:255 green:152 blue:0 andStartAngle:2*M_PI*(depositeNum + space*2 + extraNum) endAngle:2*M_PI*(depositeNum + space*2 + extraNum + tsellNum)];
    [self drawPathUseRed:205 green:111 blue:226 andStartAngle:2*M_PI*(depositeNum + space*3 + extraNum + tsellNum) endAngle:2*M_PI*(depositeNum + space*3 + extraNum + tsellNum + otherNum)];
    
    
    if ([self.model.income floatValue] < 1) {
        [self loadEmptyView:@"当天暂无数据"];
    }else{
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-180)/2, 82, 180, 20)];
        label.text = @"收入结构";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGBACOLOR(37, 37, 37, 1);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame)+5, 180, 20)];
        label1.text = [NSString stringWithFormat:@"%@", self.model.income];
        label1.font = [UIFont systemFontOfSize:15];
        label1.textColor = [UIColor blackColor];
        label1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label1];
    }
    
}



- (CAShapeLayer *)drawPathUseRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b andStartAngle:(CGFloat)start endAngle:(CGFloat)end {
    //    UIBezierPath * path;
    CGPoint center = CGPointMake(self.frame.size.width/2, 100);
    CGFloat lineWidth = 30.f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:80 startAngle:start endAngle:end clockwise:YES];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor =  RGBACOLOR(r, g, b,  1).CGColor;
    layer.lineWidth = lineWidth;
    
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 0.5;
    //    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
    
    [self.layer addSublayer:layer];
    
    return layer;
}



#pragma mark - 没有数据时
- (void)loadEmptyView:(NSString *)message
{
//    self.backgroundColor = [UIColor whiteColor];
//    
//    CATransition *animation = [CATransition animation];
//    animation.duration = 1.5f;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = @"rippleEffect";
//    animation.subtype = kCATransitionFromTop;
//    [self.window.layer addAnimation:animation forKey:nil];
    
    // 全部为空值
    NormalIconView *emptyView = [NormalIconView sharedHomeIconView];
    emptyView.iconView.image = [UIImage imageNamed:@"happyness"];
    emptyView.label.text = message;
    emptyView.label.numberOfLines = 0;
    emptyView.label.textColor = RGBACOLOR(209, 40, 123, 1);
    emptyView.backgroundColor = [UIColor clearColor];
    [self addSubview:emptyView];
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
        make.height.equalTo(@45);
    }];
}


@end
