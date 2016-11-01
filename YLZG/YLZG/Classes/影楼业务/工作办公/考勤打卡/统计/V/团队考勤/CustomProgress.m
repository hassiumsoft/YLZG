//
//  CustomProgress.m
//  Chok_passenger
//
//  Created by 任海丽 on 13-7-11.
//  Copyright (c) 2013年 任海丽. All rights reserved.
//

#import "CustomProgress.h"

@implementation CustomProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        

        
        // 背景图像
        _trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        [_trackView setImage:[UIImage imageNamed:@"wait_progress_back.png"]];
        _trackView.backgroundColor = RGBACOLOR(228, 228, 228, 1);
        _trackView.clipsToBounds = YES;//当前view的主要作用是将出界了的_progressView剪切掉，所以需将clipsToBounds设置为YES
        [self addSubview:_trackView];
        // 填充图像
        _progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, frame.size.height)];
//        [_progressView setImage:[UIImage imageNamed:@"wait_progress.png"]];
        
        [_trackView addSubview:_progressView];
        
        _currentProgress = 0.0;

        // 人数以及状态的设置
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(-6, CGRectGetMaxY(_trackView.frame)+2, 25, 14)];
        self.numLabel.textColor = RGBACOLOR(196, 196, 196, 1);
        self.numLabel.font = [UIFont systemFontOfSize:12];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.numLabel];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(-18, CGRectGetMaxY(_numLabel.frame)+2, 50, 14)];
        self.stateLabel.textColor = RGBACOLOR(196, 196, 196, 1);
        self.stateLabel.font = [UIFont systemFontOfSize:12];
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.stateLabel];
        
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    if (0 == progress) {
        self.currentProgress = 0;
        [self changeProgressViewFrame];
        return;
    }
    
    _targetProgress = progress;
    if (_progressTimer == nil)
    {
        //创建定时器 
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(moveProgress) userInfo:nil repeats:YES];
    }
}

//修改进度
- (void) moveProgress
{
    //判断当前进度是否大于进度值
    if (self.currentProgress < _targetProgress)
    {
        self.currentProgress = MIN(self.currentProgress + 0.1*_targetProgress, _targetProgress);
        if (_targetProgress >=10) {            
            [_delegate changeTextProgress:[NSString stringWithFormat:@"%d %%",(int)self.currentProgress]];
        }else{            
            [_delegate changeTextProgress:[NSString stringWithFormat:@"%.1f %%",self.currentProgress]];
        }
        
        //改变界面内容
        [self changeProgressViewFrame];
        
    } else {
        //当超过进度时就结束定时器，并处理代理方法
        [_progressTimer invalidate];
        _progressTimer = nil;
        [_delegate endTime];
    }
}
//修改显示内容
- (void)changeProgressViewFrame{
    //只要改变frame的x的坐标就能看到进度一样的效果
    float rr = self.proportion;
    _progressView.frame = CGRectMake(0, self.frame.size.height-self.frame.size.height*rr * (_currentProgress/_targetProgress), self.frame.size.width, rr *self.frame.size.height);
}

@end
