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
    
    // 更新数组缓存
    [[YLZGDataManager sharedManager] saveGroupInfoWithBlock:^{
        
    }];
    
}

- (void)didJoinGroup:(EMGroup *)aGroup inviter:(NSString *)aInviter message:(NSString *)aMessage
{
    // SDK自动同意了用户A的加B入群邀请后，用户B接收到该回调，需要设置EMOptions的isAutoAcceptGroupInvitation为YES
    
    [[YLZGDataManager sharedManager] getOneStudioByUserName:aInviter Block:^(ContactersModel *model) {
        
        NSString *message = [NSString stringWithFormat:@"%@邀请您加入群聊:%@",model.realname,aGroup.subject];
        [self showAlertMessage:message];
    }];
    
    [[YLZGDataManager sharedManager] saveGroupInfoWithBlock:^{
        
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
                {
                    // app在前台
                    
                    if ([self isPushAvailed]) {
                        [self.tabbarVC playSoundAndVibration];
                    }
                    
                    break;
                }
                case UIApplicationStateInactive:
                {
                    // 待激活状态
                    if ([self isPushAvailed]) {
                        [self.tabbarVC playSoundAndVibration];
                    }
                    break;
                }
                case UIApplicationStateBackground:
                {
                    // app在后台
                    [self.tabbarVC showNotificationWithMessage:message];
                    break;
                }
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

// 判断是否可以推送
- (BOOL)isPushAvailed
{
    EMPushOptions *pushOption = [EMClient sharedClient].pushOptions;
    if (pushOption.noDisturbStatus == EMPushNoDisturbStatusClose) {
        // 关闭免打扰==可以推送
        return YES;
    }else if(pushOption.noDisturbStatus == EMPushNoDisturbStatusDay){
        // 全天免打扰，不准推送。
        return NO;
    }else if(pushOption.noDisturbStatus == EMPushNoDisturbStatusCustom){
        // 根据时间段来判断是否可以推送:8：00 -- 22：00可以推送
        NSInteger nowHours = [[self getCurrentHours] intValue];
        NSInteger pushStart = pushOption.noDisturbingStartH;
        NSInteger pushEnd = pushOption.noDisturbingEndH;
        if (nowHours <= pushEnd && nowHours >= pushStart) {
            return YES;
        }else{
            return NO;
        }
        
    }else{
        return YES;
    }
}
// 获取当前的小时数
- (NSString *)getCurrentHours
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone]; // 上海时区
    NSDate *date = [NSDate date];
    NSInteger seconds = [timeZone secondsFromGMTForDate:date];
    NSDate *newDate = [date dateByAddingTimeInterval:seconds];
    NSString *str = [NSString stringWithFormat:@"%@",newDate];
    
    // 东八区的时间
    NSString *realTime = [str substringWithRange:NSMakeRange(5, 2)];
    return realTime;
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



#pragma mark - 为了消息警告⚠️
- (void)declineJoinGroupRequest:(NSString *)aGroupId sender:(NSString *)aUsername reason:(NSString *)aReason completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    
}
- (void)asyncDeclineInvitationFromGroup:(NSString *)aGroupId inviter:(NSString *)aUsername reason:(NSString *)aReason success:(void (^)())aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
- (void)getPublicGroupsFromServerWithCursor:(NSString *)aCursor pageSize:(NSInteger)aPageSize completion:(void (^)(EMCursorResult *, EMError *))aCompletionBlock
{
    
}
- (EMGroup *)unblockGroup:(NSString *)aGroupId error:(EMError *__autoreleasing *)pError
{
    return 0;
}
- (void)blockMembers:(NSArray *)aMembers fromGroup:(NSString *)aGroupId completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    
}
- (void)asyncDeclineJoinApplication:(NSString *)aGroupId applicant:(NSString *)aUsername reason:(NSString *)aReason success:(void (^)())aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
//- (EMCursorResult *)getPublicGroupsFromServerWithCursor:(NSString *)aCursor pageSize:(NSInteger)aPageSize error:(EMError *__autoreleasing *)pError
//{
//    return 0;
//}
- (EMGroup *)searchPublicGroupWithId:(NSString *)aGroundId error:(EMError *__autoreleasing *)pError
{
    return 0;
}
- (void)asyncAcceptInvitationFromGroup:(NSString *)aGroupId inviter:(NSString *)aUsername success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
- (void)asyncLeaveGroup:(NSString *)aGroupId success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
- (void)didReceiveDeclinedJoinGroup:(NSString *)aGroupId reason:(NSString *)aReason
{
    
}
- (void)createGroupWithSubject:(NSString *)aSubject description:(NSString *)aDescription invitees:(NSArray *)aInvitees message:(NSString *)aMessage setting:(EMGroupOptions *)aSetting completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    
}
- (void)asyncJoinPublicGroup:(NSString *)aGroupId success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
- (void)asyncBlockGroup:(NSString *)aGroupId success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
- (void)joinPublicGroup:(NSString *)aGroupId completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    
}
//- (EMCursorResult *)getPublicGroupsFromServerWithCursor:(NSString *)aCursor pageSize:(NSInteger)aPageSize error:(EMError *__autoreleasing *)pError
//{
//    return 0;
//}
- (void)asyncChangeGroupSubject:(NSString *)aSubject forGroup:(NSString *)aGroupId success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
//- (EMError *)declineJoinApplication:(NSString *)aGroupId applicant:(NSString *)aUsername reason:(NSString *)aReason
//{
//    return 0;
//}
- (void)asyncSearchPublicGroupWithId:(NSString *)aGroundId success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
- (void)asyncApplyJoinPublicGroup:(NSString *)aGroupId message:(NSString *)aMessage success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
//- (EMGroup *)createGroupWithSubject:(NSString *)aSubject description:(NSString *)aDescription invitees:(NSArray *)aInvitees message:(NSString *)aMessage setting:(EMGroupOptions *)aSetting error:(EMError *__autoreleasing *)pError
//{
//    return 0;
//}
- (void)asyncCreateGroupWithSubject:(NSString *)aSubject description:(NSString *)aDescription invitees:(NSArray *)aInvitees message:(NSString *)aMessage setting:(EMGroupOptions *)aSetting success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
-(void)updateGroupSubject:(NSString *)aSubject forGroup:(NSString *)aGroupId completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    
}
//- (EMGroup *)joinPublicGroup:(NSString *)aGroupId error:(EMError *__autoreleasing *)pError
//{
//    return 0;
//}
- (void)asyncAddOccupants:(NSArray *)aOccupants toGroup:(NSString *)aGroupId welcomeMessage:(NSString *)aWelcomeMessage success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
- (void)updatePushServiceForGroup:(NSString *)aGroupID isPushEnabled:(BOOL)aIsEnable completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    
}
- (NSArray *)getMyGroupsFromServerWithError:(EMError *__autoreleasing *)pError
{
    return 0;
}
- (void)asyncUnblockOccupants:(NSArray *)aOccupants forGroup:(NSString *)aGroupId success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
- (void)blockGroup:(NSString *)aGroupId completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    
}
- (void)asyncFetchGroupInfo:(NSString *)aGroupId includeMembersList:(BOOL)aIncludeMembersList success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
- (void)addDelegate:(id<EMGroupManagerDelegate>)aDelegate
{
    
}
- (NSArray *)getAllGroups
{
    return 0;
}
- (EMError *)declineJoinApplication:(NSString *)aGroupId applicant:(NSString *)aUsername reason:(NSString *)aReason
{
    return 0;
}
- (NSArray *)getAllIgnoredGroupIds
{
    return 0;
}
- (EMGroup *)removeOccupants:(NSArray *)aOccupants fromGroup:(NSString *)aGroupId error:(EMError *__autoreleasing *)pError
{
    return 0;
}
- (EMError *)acceptJoinApplication:(NSString *)aGroupId applicant:(NSString *)aUsername
{
    return 0;
}
- (void)asyncUnblockGroup:(NSString *)aGroupId success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    
}
-(void)asyncAcceptJoinApplication:(NSString *)aGroupId applicant:(NSString *)aUsername success:(void (^)())aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    // 批准入群申请, 需要Owner权限
}
- (NSArray *)loadAllMyGroupsFromDB
{
    return 0;
}
- (EMGroup *)addOccupants:(NSArray *)aOccupants toGroup:(NSString *)aGroupId welcomeMessage:(NSString *)aWelcomeMessage error:(EMError *__autoreleasing *)pError
{
    // 邀请用户加入群组
    return 0;
}
- (NSArray *)fetchGroupBansList:(NSString *)aGroupId error:(EMError *__autoreleasing *)pError
{
    // 获取群组黑名单列表, 需要owner权限
    return 0;
}
- (void)asyncChangeDescription:(NSString *)aDescription forGroup:(NSString *)aGroupId success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    // 更改群组说明信息, 需要owner权限
}
- (void)removeDelegate:(id)aDelegate
{
    
}
//- (void)searchPublicGroupWithId:(NSString *)aGroundId completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
//{
//    // 搜搜公共群
//}
- (void)asyncGetMyGroupsFromServer:(void (^)(NSArray *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    // 从服务器获取用户所有的群组，成功后更新DB和内存中的群组列表
}
- (void)asyncFetchGroupBansList:(NSString *)aGroupId success:(void (^)(NSArray *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    // 获取群组黑名单列表, 需要owner权限
}
- (void)asyncBlockOccupants:(NSArray *)aOccupants fromGroup:(NSString *)aGroupId success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    // 加人到群组黑名单, 需要owner权限
}
- (void)asyncIgnoreGroupPush:(NSString *)aGroupId ignore:(BOOL)aIsIgnore success:(void (^)())aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    // 屏蔽群组推送
}
- (EMGroup *)unblockOccupants:(NSArray *)aOccupants forGroup:(NSString *)aGroupId error:(EMError *__autoreleasing *)pError
{
    // 从群组黑名单中减人, 需要owner权限
    return 0;
}
- (void)asyncDestroyGroup:(NSString *)aGroupId success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    // 摧毁群组
}
-(void)addDelegate:(id<EMGroupManagerDelegate>)aDelegate delegateQueue:(dispatch_queue_t)aQueue
{
    
}
- (void)asyncRemoveOccupants:(NSArray *)aOccupants fromGroup:(NSString *)aGroupId success:(void (^)(EMGroup *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    // 将群成员移出群组, 需要owner权限
}
- (void)asyncGetPublicGroupsFromServerWithCursor:(NSString *)aCursor pageSize:(NSInteger)aPageSize success:(void (^)(EMCursorResult *))aSuccessBlock failure:(void (^)(EMError *))aFailureBlock
{
    // 获取公共群组列表
}

- (void)destroyGroup:(NSString *)aGroupId completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    // 销毁群组
}
- (EMGroup *)blockGroup:(NSString *)aGroupId error:(EMError *__autoreleasing *)pError
{
    // 屏蔽群消息，服务器不再发送此群的消息给用户，owner不能屏蔽群消息
    return 0;
}
- (void)addMembers:(NSArray *)aUsers toGroup:(NSString *)aGroupId message:(NSString *)aMessage completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    // 邀请A进群
}
- (void)updateDescription:(NSString *)aDescription forGroup:(NSString *)aGroupId completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    // 更改群组说明信息, 需要owner权限
}
- (void)removeMembers:(NSArray *)aUsers fromGroup:(NSString *)aGroupId completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    // 除以群成员
}

- (EMGroup *)applyJoinPublicGroup:(NSString *)aGroupId message:(NSString *)aMessage error:(EMError *__autoreleasing *)pError
{
    // 申请加入一个需批准的公开群组，群类型应该是EMGroupStylePublicJoinNeedApproval
    return 0;
}
- (void)approveJoinGroupRequest:(NSString *)aGroupId sender:(NSString *)aUsername completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    // 批准入群申请, 需要Owner权限
}

- (EMGroup *)createGroupWithSubject:(NSString *)aSubject description:(NSString *)aDescription invitees:(NSArray *)aInvitees message:(NSString *)aMessage setting:(EMGroupOptions *)aSetting error:(EMError *__autoreleasing *)pError
{
    // 建群
    return 0;
}
- (EMGroup *)leaveGroup:(NSString *)aGroupId error:(EMError *__autoreleasing *)pError
{
    // 退出群组，owner不能退出群，只能销毁群
    return 0;
}
- (EMGroup *)blockOccupants:(NSArray *)aOccupants fromGroup:(NSString *)aGroupId error:(EMError *__autoreleasing *)pError
{
    // 加人到群组黑名单, 需要owner权限
    return 0;
}
- (void)declineGroupInvitation:(NSString *)aGroupId inviter:(NSString *)aInviter reason:(NSString *)aReason completion:(void (^)(EMError *))aCompletionBlock
{
    // 拒绝入群邀请
}
- (NSArray *)getGroupsWithoutPushNotification:(EMError *__autoreleasing *)pError
{
    // 从内存中获取屏蔽了推送的群组ID列表
    return 0;
}
- (EMGroup *)destroyGroup:(NSString *)aGroupId error:(EMError *__autoreleasing *)pError
{
    // 解散群组, 需要owner权限
    return 0;
}
- (EMGroup *)changeDescription:(NSString *)aDescription forGroup:(NSString *)aGroupId error:(EMError *__autoreleasing *)pError
{
    // 更改群组说明信息, 需要owner权限
    return 0;
}
- (void)getGroupSpecificationFromServerByID:(NSString *)aGroupID includeMembersList:(BOOL)aIncludeMembersList completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    // 获取群组详情
}
- (EMGroup *)changeGroupSubject:(NSString *)aSubject forGroup:(NSString *)aGroupId error:(EMError *__autoreleasing *)pError
{
    // 解散群组, 需要owner权限
    return 0;
}
- (void)leaveGroup:(NSString *)aGroupId completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    // 离开群组回调
}
- (void)getJoinedGroupsFromServerWithCompletion:(void (^)(NSArray *, EMError *))aCompletionBlock
{
    // 从服务器获取用户所有的群组，成功后更新DB和内存中的群组列表
}
- (EMGroup *)fetchGroupInfo:(NSString *)aGroupId includeMembersList:(BOOL)aIncludeMembersList error:(EMError *__autoreleasing *)pError
{
    // 获取群组详情
    return 0;
}
- (void)acceptInvitationFromGroup:(NSString *)aGroupId inviter:(NSString *)aUsername completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    // 接受入群邀请
}
- (EMGroup *)acceptInvitationFromGroup:(NSString *)aGroupId inviter:(NSString *)aUsername error:(EMError *__autoreleasing *)pError
{
    // 接受入群邀请
    return 0;
}
- (void)requestToJoinPublicGroup:(NSString *)aGroupId message:(NSString *)aMessage completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    // 申请加入一个需批准的公开群组，群类型应该是EMGroupStylePublicJoinNeedApproval
}
- (void)unblockGroup:(NSString *)aGroupId completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    // 取消屏蔽群消息
}
- (EMError *)declineInvitationFromGroup:(NSString *)aGroupId inviter:(NSString *)aUsername reason:(NSString *)aReason
{
    // 拒绝入群邀请
    return 0;
}
- (void)searchPublicGroupWithId:(NSString *)aGroundId completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    // 根据群ID搜索公开群
}
- (EMGroup *)joinPublicGroup:(NSString *)aGroupId error:(EMError *__autoreleasing *)pError
{
    // 加入一个公开群组，群类型应该是EMGroupStylePublicOpenJoin
    return 0;
}
- (EMError *)ignoreGroupPush:(NSString *)aGroupId ignore:(BOOL)aIsIgnore
{
    // 屏蔽/取消屏蔽群组消息的推送
    return 0;
}
- (void)unblockMembers:(NSArray *)aMembers fromGroup:(NSString *)aGroupId completion:(void (^)(EMGroup *, EMError *))aCompletionBlock
{
    // 从群组黑名单中减人, 需要owner权限
}
- (void)autoLoginDidCompleteWithError:(EMError *)aError
{
    // 自动登录失败
}

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
{
    // 收到CMD消息
}
- (NSArray *)getJoinedGroups
{
    // 获取用户所有群组
    [[YLZGDataManager sharedManager] saveGroupInfoWithBlock:^{
        
    }];
    return 0;
}
- (void)getGroupBlackListFromServerByID:(NSString *)aGroupId completion:(void (^)(NSArray *, EMError *))aCompletionBlock
{
    // 获取群组黑名单列表
    
}
- (EMCursorResult *)getPublicGroupsFromServerWithCursor:(NSString *)aCursor pageSize:(NSInteger)aPageSize error:(EMError *__autoreleasing *)pError
{
    // 从服务器获取指定范围内的公开群
    return 0;
}


@end
