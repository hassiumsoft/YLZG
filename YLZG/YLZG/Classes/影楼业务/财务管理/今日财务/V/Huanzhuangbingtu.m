//
//  Huanzhuangbingtu.m
//  SmallYellowPerson
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Huanzhuangbingtu.h"
#import "NormalIconView.h"
#import <Masonry.h>


#define space 0

@interface Huanzhuangbingtu ()

@property (strong,nonatomic) NormalIconView *emptyBtn;

@end

@implementation Huanzhuangbingtu

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, 110, 100, 20)];
        label.text = @"财务结构";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithWhite:0.604 alpha:1.000];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame)+5, 100, 20)];
        label1.text = [NSString stringWithFormat:@"%@", self.model.income];
        label1.font = [UIFont systemFontOfSize:15];
        label1.textColor = [UIColor blackColor];
        label1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label1];
    }
    
}



- (CAShapeLayer *)drawPathUseRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b andStartAngle:(CGFloat)start endAngle:(CGFloat)end {
//    UIBezierPath * path;
    CGPoint center = CGPointMake(self.frame.size.width/2, 130);
    CGFloat lineWidth = 28.0;
    
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
    
    CATransition *animation = [CATransition animation];
    animation.duration = 2.f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromTop;
    [self.window.layer addAnimation:animation forKey:nil];
    
    // 全部为空值
    self.emptyBtn = [NormalIconView sharedHomeIconView];
    self.emptyBtn.iconView.image = [UIImage imageNamed:@"sadness"];
    self.emptyBtn.label.text = message;
    self.emptyBtn.label.numberOfLines = 0;
    self.emptyBtn.label.textColor = RGBACOLOR(219, 99, 155, 1);
    self.emptyBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.emptyBtn];
    
    
    [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@140);
    }];
}


@end
