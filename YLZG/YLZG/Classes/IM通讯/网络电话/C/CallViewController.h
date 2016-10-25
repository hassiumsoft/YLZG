//
//  CallViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#define kLocalCallBitrate @"EaseMobLocalCallBitrate"

@class EMCallSession;
@interface CallViewController : SuperViewController

{
    NSTimer *_timeTimer;
    AVAudioPlayer *_ringPlayer; // 声音播放
    
    UIView *_topView;  // 顶部视图
    UILabel *_statusLabel;  // 状态提示
    UILabel *_timeLabel;   // 时间label
    UILabel *_nameLabel;   // 对方名字
    UIImageView *_headerImageView;  // 对方头像
    
    //操作按钮显示
    UIView *_actionView;
    UIButton *_silenceButton;// 静音按钮
    UIButton *_speakerOutButton; // 免提按钮
    UIButton *_rejectButton; // 拒接按钮
    UIButton *_answerButton; // 接听按钮
    UIButton *_cancelButton;  // 取消按钮
    UIButton *_recordButton;  // 1.录制视频按钮
    UIButton *_videoButton;  // 2.视频开启按钮
    UIButton *_voiceButton;   // 3.音频开启按钮
    UIButton *_switchCameraButton;  // 切换摄像头按钮
}
/** 通话状态label */
@property (strong, nonatomic) UILabel *statusLabel;
/** 通话时间label */
@property (strong, nonatomic) UILabel *timeLabel;
/** 拒接按钮 */
@property (strong, nonatomic) UIButton *rejectButton;
/** 接听按钮 */
@property (strong, nonatomic) UIButton *answerButton;
/** 取消按钮 */
@property (strong, nonatomic) UIButton *cancelButton;

- (instancetype)initWithSession:(EMCallSession *)session
                       isCaller:(BOOL)isCaller
                         status:(NSString *)statusString;

/** 可以视频 */
+ (BOOL)canVideo;
/** 保存比特率 */
+ (void)saveBitrate:(NSString*)value;
/** 开始播放声音 */
- (void)beginRing;
/** 开始计时 */
- (void)startTimer;
/** 关闭通话 */
- (void)close;
/** 设置网络状况 */
- (void)setNetwork:(EMCallNetworkStatus)status;

@end
