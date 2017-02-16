//
//  CallViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CallViewController.h"
#import "YLZGChatManager.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "YLZGDataManager.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>


#define ButtonWH 70

@interface CallViewController ()

{
    __weak EMCallSession *_callSession;
    BOOL _isCaller; // 发起通话的人
    NSString *_status;
    int _timeLength;
    
    NSString * _audioCategory;
    
    //视频属性显示区域
    UIView *_propertyView;
    UILabel *_sizeLabel;
    UILabel *_timedelayLabel;
    UILabel *_framerateLabel;
    UILabel *_lostcntLabel;
    UILabel *_remoteBitrateLabel;
    UILabel *_localBitrateLabel;
    NSTimer *_propertyTimer;
    //弱网检测
    UILabel *_networkLabel;
}
/** 对方的信息模型 */
@property (strong,nonatomic) ContactersModel *userModel;

@end

@implementation CallViewController


#pragma mark - 初始化
- (instancetype)initWithSession:(EMCallSession *)session
                       isCaller:(BOOL)isCaller
                         status:(NSString *)statusString
{
    self = [super init];
    if (self) {
        _callSession = session;
        _isCaller = isCaller;
        _timeLabel.text = @"";
        _timeLength = 0;
        _status = statusString;
        
        [[YLZGDataManager sharedManager] getOneStudioByUserName:_callSession.remoteName Block:^(ContactersModel *model) {
            _userModel = model;
        }];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if ([ud valueForKey:kLocalCallBitrate] && _callSession.type == EMCallTypeVideo) {

            EMCallOptions *open = [[EMClient sharedClient].callManager getCallOptions];
            [open maxVideoKbps];
//            [open setVideoKbps:[[ud valueForKey:kLocalCallBitrate] intValue]];
            
        }
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    _nameLabel.text = self.userModel.nickname.length >= 1 ? self.userModel.nickname : self.userModel.realname;
    _statusLabel.text = _status;
    if (_isCaller) {
        self.rejectButton.hidden = YES;
        self.answerButton.hidden = YES;
        self.cancelButton.hidden = NO;
        _propertyView.hidden = YES;
    }
    else{
        self.rejectButton.hidden = NO;
        self.answerButton.hidden = NO;
        _propertyView.hidden = YES;
    }
    
    if (_callSession.type == EMCallTypeVideo) {
        // 如果是视频通话
        [self setupVideoView];
        [self.view bringSubviewToFront:_topView];
        [self.view bringSubviewToFront:_actionView];
    }
}


#pragma mark - 创建初始界面
- (void)setupSubviews
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    if (SCREEN_WIDTH == 375) {
        // iP6
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cm2_fm_bg-ip6"]];
    }else{
        // 其他尺寸
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cm2_fm_bg"]];
    }
    
    // 顶部视图
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.height/2)];
    _topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topView];
    
    
    // 状态栏 - 和名字合并
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:self.statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topView.mas_left).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        make.top.equalTo(_topView.mas_top).offset(30);
    }];
    
    
    // 对方头像
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = 55;
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    [_topView addSubview:_headerImageView];
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topView.mas_centerX);
        make.top.equalTo(_topView.mas_top).offset(60);
        make.width.and.height.equalTo(@110);
    }];
    
    // 时间显示
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topView.mas_centerX);
        make.top.equalTo(_headerImageView.mas_bottom);
        make.height.equalTo(@21);
    }];
    
    // 对方名字
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = _callSession.remoteName;
    [_topView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom);
        make.centerX.equalTo(_topView.mas_centerX);
        make.height.equalTo(@21);
    }];
    
    // 网络状况
    _networkLabel = [[UILabel alloc] init];
    _networkLabel.font = [UIFont systemFontOfSize:14.0];
    _networkLabel.backgroundColor = [UIColor clearColor];
    _networkLabel.textColor = [UIColor whiteColor];
    _networkLabel.textAlignment = NSTextAlignmentCenter;
    _networkLabel.hidden = YES;
    [_topView addSubview:_networkLabel];
    [_networkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topView.mas_centerX);
        make.height.equalTo(@21);
        make.top.equalTo(_nameLabel.mas_bottom);
    }];
    
    
    
    // 底部视图
    _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 260, self.view.frame.size.width, 260)];
    _actionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_actionView];
    
    // 静音
    CGFloat tmpWidth = _actionView.frame.size.width / 2;
    _silenceButton = [[UIButton alloc] initWithFrame:CGRectMake((tmpWidth - 40) / 2, 0, ButtonWH*0.88, ButtonWH*0.88)];
    [_silenceButton setBackgroundImage:[UIImage imageNamed:@"call_jingying"] forState:UIControlStateNormal];
    [_silenceButton addTarget:self action:@selector(silenceAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_silenceButton];
    
    
    // 免提
    _speakerOutButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 40) / 2, _silenceButton.frame.origin.y, ButtonWH*0.88, ButtonWH*0.88)];
    [_speakerOutButton setBackgroundImage:[UIImage imageNamed:@"call_mianti"] forState:UIControlStateNormal];
    [_speakerOutButton addTarget:self action:@selector(speakerOutAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_speakerOutButton];
    
    
    // 拒接
//    _rejectButton = [[UIButton alloc] init];
//    [_rejectButton setBackgroundImage:[UIImage imageNamed:@"call_juejie"] forState:UIControlStateNormal];
//    [_rejectButton addTarget:self action:@selector(rejectAction) forControlEvents:UIControlEventTouchUpInside];
//    [_actionView addSubview:_rejectButton];
//    [_rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_silenceButton.mas_centerX);
//        make.width.and.height.equalTo(@ButtonWH);
//        make.top.equalTo(_silenceButton.mas_bottom);
//    }];
    
    // 接听
    _answerButton = [[UIButton alloc] init];
    [_answerButton setImage:[UIImage imageNamed:@"call_answer"] forState:UIControlStateNormal];
    [_answerButton setBackgroundColor:MainColor];
    _answerButton.layer.masksToBounds = YES;
    _answerButton.layer.cornerRadius = ButtonWH/2;
    [_answerButton addTarget:self action:@selector(answerAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_answerButton];
    [_answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_actionView.mas_centerX);
        make.top.equalTo(_speakerOutButton.mas_bottom).offset(5);
        make.width.and.height.equalTo(@(ButtonWH));
    }];
    
    
    // 挂断电话
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton setImage:[UIImage imageNamed:@"call_guaduan"] forState:UIControlStateNormal];
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.cornerRadius = ButtonWH/2;
    [_cancelButton setBackgroundColor:[UIColor redColor]];
    [_cancelButton addTarget:self action:@selector(hangupAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_actionView.mas_centerX);
        make.bottom.equalTo(_actionView.mas_bottom).offset(-20);
        make.width.and.height.equalTo(@(ButtonWH));
    }];
    
}

#pragma mark - 创建视频通话界面
- (void)setupVideoView
{
    
    //1.对方窗口
    _callSession.remoteVideoView = [[EMCallRemoteView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:_callSession.remoteVideoView];
    
    //2.自己窗口
    CGFloat width = 80;
    CGFloat height = self.view.frame.size.height / self.view.frame.size.width * width;
    _callSession.localVideoView = [[EMCallLocalView alloc] initWithFrame:CGRectMake(self.view.width - 90, 21, width, height)];
    [self.view addSubview:_callSession.localVideoView];
    
    // 切换摄像头
    _switchCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 70, height + 21 + 5, 55, 45)];
    [_switchCameraButton setBackgroundImage:[UIImage imageNamed:@"call_switch"] forState:UIControlStateNormal];
    [_switchCameraButton addTarget:self action:@selector(switchCameraAction) forControlEvents:UIControlEventTouchUpInside];
    _switchCameraButton.userInteractionEnabled = YES;
    [_topView addSubview:_switchCameraButton];
    
    //3、属性显示层
    _propertyView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(_actionView.frame) - 90, self.view.frame.size.width - 20, 90)];
    _propertyView.backgroundColor = [UIColor clearColor];
    _propertyView.hidden = NO;
    [self.view addSubview:_propertyView];
    
    
    width = (CGRectGetWidth(_propertyView.frame) - 20) / 2;
    height = CGRectGetHeight(_propertyView.frame) / 3;
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _sizeLabel.backgroundColor = [UIColor clearColor];
    _sizeLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_sizeLabel];
    
    // 时间延迟
    _timedelayLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    _timedelayLabel.backgroundColor = [UIColor clearColor];
    _timedelayLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_timedelayLabel];
    
    _framerateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height, width, height)];
    _framerateLabel.backgroundColor = [UIColor clearColor];
    _framerateLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_framerateLabel];
    
    _lostcntLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, height, width, height)];
    _lostcntLabel.backgroundColor = [UIColor clearColor];
    _lostcntLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_lostcntLabel];
    
    
    _localBitrateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height * 2, width, height)];
    _localBitrateLabel.backgroundColor = [UIColor clearColor];
    _localBitrateLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_localBitrateLabel];
    
    // 比特率
    _remoteBitrateLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, height * 2, width, height)];
    _remoteBitrateLabel.backgroundColor = [UIColor clearColor];
    _remoteBitrateLabel.textColor = [UIColor redColor];
    [_propertyView addSubview:_remoteBitrateLabel];
    
    
}

#pragma mark - 开始响铃
- (void)beginRing
{
    [_ringPlayer stop];
    
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"call" ofType:@"caf"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_ringPlayer setVolume:1];
    _ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    if([_ringPlayer prepareToPlay])
    {
        [_ringPlayer play]; //播放
    }
}

- (void)_stopRing
{
    [_ringPlayer stop];
}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    int hour = _timeLength / 3600;
    int m = (_timeLength - hour * 3600) / 60;
    int s = _timeLength - hour * 3600 - m * 60;
    
    if (hour > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i:%i", hour, m, s];
    }
    else if(m > 0){
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i", m, s];
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"00:%i", s];
    }
}


#pragma mark - 切换摄像头
- (void)switchCameraAction
{
    [_callSession switchCameraPosition:_switchCameraButton.selected];
    _switchCameraButton.selected = !_switchCameraButton.selected;
}

#pragma mark - 视频通话中断
- (void)videoPauseAction
{
    _videoButton.selected = !_videoButton.selected;
    if (_videoButton.selected) {
        [_callSession pauseVideo];
        
    } else {
        [_callSession resumeVideo];
    }
}
#pragma mark - 语音通话中断
- (void)voicePauseAction
{
    _voiceButton.selected = !_voiceButton.selected;
    
    if (_voiceButton.selected) {
        [_callSession pauseVoice];
    } else {
        [_callSession resumeVoice];
    }
}
#pragma mark - 静音
- (void)silenceAction
{
    _silenceButton.selected = !_silenceButton.selected;
    [_callSession pauseVoice];
}
#pragma mark - 免提电话
- (void)speakerOutAction
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (_speakerOutButton.selected) {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }else {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
    [audioSession setActive:YES error:nil];
    _speakerOutButton.selected = !_speakerOutButton.selected;
}
#pragma mark - 接听电话
- (void)answerAction
{
    [self _stopRing];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    _audioCategory = audioSession.category;
    if(![_audioCategory isEqualToString:AVAudioSessionCategoryPlayAndRecord]){
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
    
    [[YLZGChatManager sharedManager] answerCall];
}
#pragma mark - 挂断电话
- (void)hangupAction
{
    [_timeTimer invalidate];
    [self _stopRing];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:_audioCategory error:nil];
    [audioSession setActive:YES error:nil];
    
    [[YLZGChatManager sharedManager] hangupCallWithReason:EMCallEndReasonHangup];
}
#pragma mark - 拒接电话
- (void)rejectAction
{
    [_timeTimer invalidate];
    [self _stopRing];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:_audioCategory error:nil];
    [audioSession setActive:YES error:nil];
    
    [[YLZGChatManager sharedManager] hangupCallWithReason:EMCallEndReasonDecline];
}

#pragma mark - 协助方法
+ (BOOL)canVideo
{
    if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        if(!([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized)){
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"没有摄像头权限" message:@"请前往设置授权" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
            return NO;
        }
    }
    
    return YES;
}

+ (void)saveBitrate:(NSString*)value
{
    NSScanner* scan = [NSScanner scannerWithString:value];
    int val;
    if ([scan scanInt:&val] && [scan isAtEnd]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:value forKey:kLocalCallBitrate];
        [ud synchronize];
    }
}

- (void)startTimer
{
    _timeLength = 0;
    _timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
}

#pragma mark - 网络变化了
- (void)setNetwork:(EMCallNetworkStatus)status
{
    switch (status) {
        case EMCallNetworkStatusNormal:
        {
            _networkLabel.text = @"网络稳定";
            _networkLabel.hidden = YES;
        }
            break;
        case EMCallNetworkStatusUnstable:
        {
            _networkLabel.text = @"当前网络不稳定";
            _networkLabel.hidden = NO;
        }
            break;
        case EMCallNetworkStatusNoData:
        {
            _networkLabel.text = @"没有通话数据";
            _networkLabel.hidden = NO;
        }
            break;
        default:
            break;
    }
}
#pragma mark - 挂断电话
- (void)close
{
    _callSession.remoteVideoView.hidden = YES;
    _callSession = nil;
    _propertyView = nil;
    
    if (_timeTimer) {
        [_timeTimer invalidate];
        _timeTimer = nil;
    }
    
    if (_propertyTimer) {
        [_propertyTimer invalidate];
        _propertyTimer = nil;
    }
    
    [YLNotificationCenter postNotificationName:KNOTIFICATION_CALL object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}



@end
