//
//  YLZGChatManager.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "YLZGChatManager.h"
#import "YLZGDataManager.h"
#import "ZCAccountTool.h"


#define RedpacketKeyRedpacketTakenMessageSign @"RedpacketKeyRedpacketTakenMessageSign"
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface YLZGChatManager ()<EMClientDelegate,EMCallManagerDelegate,EMChatManagerDelegate,EMGroupManagerDelegate,IEMGroupManager,EMContactManagerDelegate>
{
    NSTimer *_callTimer;
}
@end

static YLZGChatManager *chatManager = nil;

@implementation YLZGChatManager


#pragma mark - 单例初始化
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatManager = [[YLZGChatManager alloc]init];
    });
    return chatManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 客户端代理
        [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
        // 群组代理
        [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
        // 好友代理
        [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
        // 聊天代理
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        // 打电话的代理
        [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
        
        [YLNotificationCenter addObserver:self selector:@selector(makeCall:) name:KNOTIFICATION_CALL object:nil];
    }
    return self;
}
#pragma mark - 从服务器获取推送属性
- (void)asyncPushOptions
{
    dispatch_async(ZCGlobalQueue, ^{
        [[EMClient sharedClient] getPushNotificationOptionsFromServerWithCompletion:^(EMPushOptions *aOptions, EMError *aError) {
            
        }];
    });
}
#pragma mark - 好友关系的回调 - IEMGroupManager
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage
{
    // 用户B申请加A为好友后，用户A会收到这个回调
    // 先本地通知-->前台展示
    [[YLZGDataManager sharedManager] getOneStudioByUserName:aUsername Block:^(ContactersModel *model) {
        NSString *name = model.nickname.length >= 1 ? model.nickname : model.realname;
        NSString *message = [NSString stringWithFormat:@"%@申请添加您为好友",name];
        [self showAlertMessage:message];
        [_tabbarVC loadUntreatedApplyCount];
        
    }];
    
}
- (void)friendRequestDidApproveByUser:(NSString *)aUsername
{
    // 用户B同意用户A的加好友请求后，用户A会收到这个回调
    [[YLZGDataManager sharedManager] getOneStudioByUserName:aUsername Block:^(ContactersModel *model) {
        NSString *name = model.nickname.length >= 1 ? model.nickname : model.realname;
        NSString *message = [NSString stringWithFormat:@"%@同意了您的好友申请",name];
        [self pullLocalNotification:message];
    }];
}
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername
{
    // 用户B拒绝用户A的加好友请求后，用户A会收到这个回调
    [[YLZGDataManager sharedManager] getOneStudioByUserName:aUsername Block:^(ContactersModel *model) {
        NSString *name = model.nickname.length >= 1 ? model.nickname : model.realname;
        NSString *message = [NSString stringWithFormat:@"%@拒绝了您的好友申请",name];
        [self pullLocalNotification:message];
    }];
}
- (void)friendshipDidAddByUser:(NSString *)aUsername
{
    // 用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
    [[YLZGDataManager sharedManager] getOneStudioByUserName:aUsername Block:^(ContactersModel *model) {
        NSString *name = model.nickname.length >= 1 ? model.nickname : model.realname;
        NSString *message = [NSString stringWithFormat:@"%@已经是您的好友",name];
        [self pullLocalNotification:message];
    }];
    
}
- (void)friendshipDidRemoveByUser:(NSString *)aUsername
{
    // 用户B删除与用户A的好友关系后，用户A会收到这个回调
    
}
#pragma mark - 群组回调相关 - EMGroupManagerDelegate
- (void)didLeaveGroup:(EMGroup *)aGroup reason:(EMGroupLeaveReason)aReason
{
    // 更新数组缓存
    [[YLZGDataManager sharedManager] saveGroupInfoWithBlock:^{
        
    }];
    
    NSString *groupName = aGroup.subject;
    if (aReason == EMGroupLeaveReasonBeRemoved) {
        // 被除移
        [self showAlertMessage:[NSString stringWithFormat:@"您已被移除[%@]群",groupName]];
    }else if (aReason == EMGroupLeaveReasonDestroyed){
        // 被解散
        [self showAlertMessage:[NSString stringWithFormat:@"您所在的[%@]群已解散",groupName]];
    }else{
        // 自己离开
        [self showAlertMessage:[NSString stringWithFormat:@"您已离开[%@]群",groupName]];
    }
    
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:_tabbarVC.navigationController.viewControllers];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in vcArray)
    {
        if ([viewController isKindOfClass:[ChatViewController class]] && [aGroup.groupId isEqualToString:[(ChatViewController *)viewController conversation].conversationId])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    if (chatViewContrller)
    {
        [vcArray removeObject:chatViewContrller];
        if ([vcArray count] > 0) {
            [_tabbarVC.navigationController setViewControllers:@[vcArray[0]] animated:YES];
        } else {
            [_tabbarVC.navigationController setViewControllers:vcArray animated:YES];
        }
    }
    
}

- (void)didJoinGroup:(EMGroup *)aGroup inviter:(NSString *)aInviter message:(NSString *)aMessage
{
    // SDK自动同意了用户A的加B入群邀请后，用户B接收到该回调，需要设置EMOptions的isAutoAcceptGroupInvitation为YES
    [[YLZGDataManager sharedManager] saveGroupInfoWithBlock:^{
        
    }];
    
    [[YLZGDataManager sharedManager] getOneStudioByUserName:aInviter Block:^(ContactersModel *model) {
        
        NSString *message = [NSString stringWithFormat:@"%@邀请您加入群聊:%@",model.realname,aGroup.subject];
        [self showAlertMessage:message];
    }];
    
}
- (void)groupInvitationDidReceive:(NSString *)aGroupId inviter:(NSString *)aInviter message:(NSString *)aMessage
{
    // 用户A邀请用户B入群,用户B接收到该回调
    if (!aGroupId || !aInviter) {
        return;
    }
    [[YLZGDataManager sharedManager] getOneStudioByUserName:aInviter Block:^(ContactersModel *model) {
        NSString *message = [NSString stringWithFormat:@"%@邀请你加入%@群聊。备注：%@",model.realname,aGroupId,aMessage];
        [self showAlertMessage:message];
        
        if (self.tabbarVC) {
            // tabbar的红点
//            self.tabbarVC setup
        }
        
        if (self.contactListVC) {
            // 显示通讯录的红点
            [self.contactListVC refreshUntreatedApplys];
        }
        
    }];
    
}

- (void)joinGroupRequestDidDecline:(NSString *)aGroupId reason:(NSString *)aReason
{
    // 群主拒绝用户A的入群申请后，用户A会接收到该回调
    if (!aReason || aReason.length == 0) {
        aReason = [NSString stringWithFormat:@"被拒绝加入%@群", aGroupId];
    }
    [self showAlertMessage:aReason];
}
- (void)joinGroupRequestDidApprove:(EMGroup *)aGroup
{
    // 群主同意用户A的入群申请后，用户A会接收到该回调
    [[YLZGDataManager sharedManager] saveGroupInfoWithBlock:^{
        NSString *message = [NSString stringWithFormat:@"同意并已加入%@群",aGroup.subject];
        [self showAlertMessage:message];
    }];
    
}

#pragma mark - 创建实时回话-EMClientDelegate
// 收到通知
- (void)makeCall:(NSNotification*)notify
{
    if (notify.object) {
        [self makeCallWithUsername:[notify.object valueForKey:@"chatter"] isVideo:[[notify.object objectForKey:@"type"] boolValue]];
    }
}
#pragma mark - 开始打电话
- (void)makeCallWithUsername:(NSString *)aUsername
                     isVideo:(BOOL)aIsVideo
{
    if ([aUsername length] == 0) {
        return;
    }
    
    if (aIsVideo) {
        // 视频通话
        [[EMClient sharedClient].callManager startVideoCall:aUsername completion:^(EMCallSession *aCallSession, EMError *aError) {
            _callSession = aCallSession;
            if(_callSession){
                [self startCallTimer];
                
                _callController = [[CallViewController alloc] initWithSession:_callSession isCaller:YES status:@"连接中..."];
                [_tabbarVC presentViewController:_callController animated:NO completion:nil];
            }else{
                [self showAlertMessage:@"创建实时通话失败，请稍后重试。"];
            }
        }];
    }else{
        // 语音通话
        [[EMClient sharedClient].callManager startVoiceCall:aUsername completion:^(EMCallSession *aCallSession, EMError *aError) {
            _callSession = aCallSession;
            if(_callSession){
                [self startCallTimer];
                
                _callController = [[CallViewController alloc] initWithSession:_callSession isCaller:YES status:@"连接中···"];
                [_tabbarVC presentViewController:_callController animated:NO completion:nil];
            }else{
                [self showAlertMessage:@"创建实时通话失败，请稍后重试。"];
            }
        }];
    }
    
}
// 开始呼叫电话
- (void)startCallTimer
{
    _callTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(cancelCall) userInfo:nil repeats:NO];
}
// 取消通话
- (void)cancelCall
{
    [self hangupCallWithReason:EMCallEndReasonNoResponse];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"对方无响应，自动挂断。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
#pragma mark - 实时通话的方法
// 接到电话，应答
- (void)answerCall
{
    
    if (_callSession) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient].callManager answerIncomingCall:_callSession.sessionId];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error.code == EMErrorNetworkUnavailable) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前网络连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    }else{
                        [self hangupCallWithReason:EMCallEndReasonFailed];
                    }
                });
            }
        });
    }
}
// 挂断电话
- (void)hangupCallWithReason:(EMCallEndReason)aReason
{
    [self stopCallTimer];
    // 自己这里
    switch (aReason) {
        case EMCallEndReasonHangup:
        {
            [self showAlertMessage:@"已挂断电话"];
            break;
        }
        case EMCallEndReasonNoResponse:
        {
            [self showAlertMessage:@"没有无响应"];
            break;
        }
        case EMCallEndReasonDecline:
        {
            [self showAlertMessage:@"已拒接"];
            break;
        }
        case EMCallEndReasonBusy:
        {
            [self showAlertMessage:@"正忙 请稍后再试"];
            break;
        }
        case EMCallEndReasonFailed:
        {
            [self showAlertMessage:@"呼叫失败 请稍后重试"];
            break;
        }
        default:
            break;
    }
    
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.sessionId reason:aReason];
    }
    _callSession = nil;
    [_callController close];
    _callController = nil;
}
- (void)stopCallTimer
{
    if (_callTimer == nil) {
        return;
    }
    
    [_callTimer invalidate];
    _callTimer = nil;
}

#pragma mark - 接收到网络电话
// A打电话给B,B会收到这个回调
- (void)callDidReceive:(EMCallSession *)aSession
{
    if(_callSession && _callSession.status != EMCallSessionStatusDisconnected){
        [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonBusy];
    }
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonFailed];
    }
    
    _callSession = aSession;
    if(_callSession){
        [self startCallTimer];
        
        _callController = [[CallViewController alloc] initWithSession:_callSession isCaller:NO status:@"完成连接"];
        [_callController beginRing];
        _callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [_tabbarVC presentViewController:_callController animated:NO completion:nil];
    }
}
// 通话已连接
- (void)callDidConnect:(EMCallSession *)aSession
{
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
        _callController.statusLabel.text = @"连接成功";
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
}
// 电话接通了
- (void)callDidAccept:(EMCallSession *)aSession
{
    // 客户端不在前台展示
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonFailed];
    }
    
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
        [self stopCallTimer];
        _callController.statusLabel.text = @"";
        _callController.timeLabel.hidden = NO;
        [_callController startTimer];
//        [_callController startShowInfo]; // 显示视频通话码率
        _callController.cancelButton.hidden = NO;
        _callController.rejectButton.hidden = YES;
        _callController.answerButton.hidden = YES;
    }
}
// A或B结束通话后，对方会收到该回调 --- 通话出现错误，双方都会接收到此回调
- (void)callDidEnd:(EMCallSession *)aSession reason:(EMCallEndReason)aReason error:(EMError *)aError
{
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
        [self stopCallTimer];
        _callSession = nil;
        [_callController close];
        _callController = nil;
        if (aError) {
            if (aError.code == 802) {
                [self showAlertMessage:@"对方不在线，请通知对方\r打开影楼掌柜。"];
            }else{
                [self showAlertMessage:aError.errorDescription];
            }
        }else{
            switch (aReason) {
                case EMCallEndReasonHangup:
                {
                    [self showAlertMessage:@"已挂断通话"];
                    break;
                }
                case EMCallEndReasonNoResponse:
                {
                    [self showAlertMessage:@"无响应"];
                    break;
                }
                case EMCallEndReasonDecline:
                {
                    [self showAlertMessage:@"拒接通话"];
                    break;
                }
                case EMCallEndReasonBusy:
                {
                    [self showAlertMessage:@"正忙 请稍后再试"];
                    break;
                }
                case EMCallEndReasonFailed:
                {
                    [self showAlertMessage:@"呼叫失败 请稍后重试"];
                    break;
                }
                default:
                    break;
            }
        }
    }
}
- (void)callNetworkStatusDidChange:(EMCallSession *)aSession status:(EMCallNetworkStatus)aStatus
{
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
        [_callController setNetwork:aStatus];
    }
}

#pragma mark - 登录状态监听
- (void)userAccountDidLoginFromOtherDevice
{
    [self clearChatManager];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前账号已在其他设备登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [YLNotificationCenter postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    
    
}
- (void)userAccountDidRemoveFromServer
{
    [self clearChatManager];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前账号已从服务器除移，请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [YLNotificationCenter postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState
{
    // 网络状态发生了变化
    [self.tabbarVC networkChanged:aConnectionState];
    
}
- (void)didAutoLoginWithError:(EMError *)error
{
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"自动登录失败，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
    }
}

#pragma mark - IM消息相关-EMChatManagerDelegate
- (void)asyncConversationFromDB
{
    __weak typeof(self) weakself = self;
    dispatch_async(ZCGlobalQueue, ^{
        NSArray *dbArray = [[EMClient sharedClient].chatManager getAllConversations];
        KGLog(@"消息列表 = %@",dbArray);
        [dbArray enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL * _Nonnull stop) {
            if(conversation.latestMessage == nil){
                
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:NO completion:^(NSString *aConversationId, EMError *aError) {
                    
                }];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakself.chatListVC) {
                [weakself.chatListVC getDataFromRAM];
            }
            
            if (weakself.tabbarVC) {
                [weakself.tabbarVC loadUnreadMessageCount];
            }
        });
        
    });
    
}

- (void)conversationListDidUpdate:(NSArray *)aConversationList
{
    // 消息列表发生了变化
    if (self.tabbarVC) {
        [_tabbarVC loadUnreadMessageCount];
    }
    
    if (self.chatListVC) {
        [_chatListVC getDataFromRAM];
    }
}
- (void)messagesDidReceive:(NSArray *)aMessages
{
    // 您收到了一条消息
    BOOL isRefreshCons = YES;
    for (EMMessage *message in aMessages) {
        BOOL needShowNoti = (message.chatType != EMChatTypeChat) ? [self isNeedShowNotification:message.conversationId] : YES;
// #warning 屏蔽红包被抢消息的提示
        if (IsRedPorket) {
            NSDictionary *dict = message.ext;
            needShowNoti = (dict && [dict valueForKey:RedpacketKeyRedpacketTakenMessageSign]) ? NO : needShowNoti;
        }
        
        if (needShowNoti) {
#if !TARGET_IPHONE_SIMULATOR
            UIApplicationState state = [[UIApplication sharedApplication] applicationState];
            switch (state) {
                case UIApplicationStateActive:
                    [self.tabbarVC playSoundAndVibration];
                    break;
                case UIApplicationStateInactive:
                    [self.tabbarVC playSoundAndVibration];
                    break;
                case UIApplicationStateBackground:
                    [self.tabbarVC showNotificationWithMessage:message];
                    break;
                default:
                    break;
            }
#endif
        }
        
        if (_chatVC == nil) {
            _chatVC = [self getCurrentChatView];
        }
        BOOL isChatting = NO;
        if (_chatVC) {
            isChatting = [message.conversationId isEqualToString:_chatVC.conversation.conversationId];
        }
        if (_chatVC == nil || !isChatting) {
            if (self.chatListVC) {
                [_chatListVC getDataFromRAM];
            }
            
            if (self.tabbarVC) {
                // 没调用
                [_tabbarVC loadUnreadMessageCount];
            }
            return;
        }
        
        if (isChatting) {
            isRefreshCons = NO;
        }
        
    }
    
    if (isRefreshCons) {
        if (self.chatListVC) {
            [_chatListVC getDataFromRAM];
        }
        
        if (self.tabbarVC) {
            [_tabbarVC loadUnreadMessageCount];
        }
    }
    
}



- (ChatViewController *)getCurrentChatView
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:_tabbarVC.navigationController.viewControllers];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    return chatViewContrller;
}

#pragma mark - 清除代理
- (void)clearChatManager
{
    self.tabbarVC = nil;
    self.chatListVC = nil;
    self.contactListVC = nil;
    self.callController = nil;
    self.chatVC = nil;
    [[EMClient sharedClient] logout:NO completion:^(EMError *aError) {
        
    }];
    
    [self hangupCallWithReason:EMCallEndReasonFailed];
}

- (BOOL)isNeedShowNotification:(NSString *)fromChatter
{
    // 判断该条消息是否该被屏蔽推送
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getGroupsWithoutPushNotification:nil];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}

- (void)pullLocalNotification:(NSString *)message
{
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    //#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    notification.alertBody = message;
    notification.alertBody = [[NSString alloc] initWithFormat:@"%@", notification.alertBody];
    
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.tabbarVC.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.tabbarVC.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.tabbarVC.lastPlaySoundDate = [NSDate date];
    }
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)showAlertMessage:(NSString *)message
{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertV show];
}


@end
