//
//  YLZGChatManager.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTabbarController.h"
#import "ChatListViewController.h"
#import "ContactListViewController.h"
#import "CallViewController.h"
#import "ChatViewController.h"


@interface YLZGChatManager : NSObject

/** 从服务器获取推送属性 */
- (void)asyncPushOptions;
/** 群组相关 */
//- (void)asyncGroupFromServer;
/** 从数据库获取回话列表 */
- (void)asyncConversationFromDB;
/** 呼出电话 */
- (void)makeCallWithUsername:(NSString *)aUsername
                     isVideo:(BOOL)aIsVideo;
/** 挂断电话 */
- (void)hangupCallWithReason:(EMCallEndReason)aReason;
/** 应答 */
- (void)answerCall;


/** tabbar */
@property (weak,nonatomic) HomeTabbarController *tabbarVC;
/** 消息列表 */
@property (weak,nonatomic) ChatListViewController *chatListVC;
/** 聊天界面 */
@property (weak,nonatomic) ChatViewController *chatVC;
/** 通讯录 */
@property (weak,nonatomic) ContactListViewController *contactListVC;

/** EMCallSession */
@property (strong, nonatomic) EMCallSession *callSession;
/** 网络电话 */
@property (strong, nonatomic) CallViewController *callController;
/** 单例初始化 */
+ (instancetype)sharedManager;

@end
