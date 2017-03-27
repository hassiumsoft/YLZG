//
//  HomeTabbarController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTabbarController : UITabBarController

{
    EMConnectionState _connectionState; // 网络状况变化了
}
/** 收到消息时的声音间隔 */
@property (strong, nonatomic) NSDate *lastPlaySoundDate;

// 网络状况变化了
- (void)networkChanged:(EMConnectionState)connectionState;
// 接收到推送消息时
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
// 跳转到消息界面
- (void)jumpToChatList:(NSDictionary *)dict;
// 未读消息统计
- (void)loadUnreadMessageCount;
// 未统计消息
- (void)loadUntreatedApplyCount;
// 发出推送声音
- (void)playSoundAndVibration;
// 收到一条消息
- (void)showNotificationWithMessage:(EMMessage *)message;

@end
