//
//  HomeTabbarController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HomeTabbarController.h"
#import "NewFutherViewController.h"
#import "HomeViewController.h"
#import "ChatListViewController.h"
#import "ContactListViewController.h"
#import "WoViewController.h"
#import "AppDelegate.h"
#import <MJExtension.h>
#import "YLZGDataManager.h"
#import "YLGroup.h"
#import "AddFriendViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "YLZGChatManager.h"
#import "ChatViewController.h"
#import "GroupListManager.h"
#import "EMCDDeviceManager.h"
#import "HomeNavigationController.h"
#import "EaseConvertToCommonEmoticonsHelper.h"


//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";


@interface HomeTabbarController ()<EMCallManagerDelegate>

{
    HomeViewController *_homeVC;
    ChatListViewController *_chatListVC;
    ContactListViewController *_contactVC;
    WoViewController *_woVC;
}

@property (strong,nonatomic) NSMutableArray *tabbarArray;

@end

@implementation HomeTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    NSString *version = [EMClient sharedClient].version;
    KGLog(@"环信版本号 == %@",version);
    
    // 未读消息数
    [YLNotificationCenter addObserver:self selector:@selector(loadUnreadMessageCount) name:HXSetupUnreadMessageCount object:nil];
    // 未处理的请求
    [YLNotificationCenter addObserver:self selector:@selector(loadUntreatedApplyCount) name:HXSetupUntreatedApplyCount object:nil];
    // 从主界面进入聊天界面
    [YLNotificationCenter addObserver:self selector:@selector(PushToChatVC:) name:HXRePushToChat object:nil];
    
    // 刚进来获取未读消息数
    [self loadUnreadMessageCount];
    // 刚进来获取未处理的审批数
    [self loadUntreatedApplyCount];
    
    [YLZGChatManager sharedManager].chatListVC = _chatListVC;//消息列表
    [YLZGChatManager sharedManager].contactListVC = _contactVC;// 通讯录
    [YLZGChatManager sharedManager].tabbarVC = self;// tabbar
    
}
#pragma mark - 加载UI视图
- (void)setupSubViews
{
    self.selectedIndex = 0;
    self.title = @"我的影楼";
    
    if ([[YLZGDataManager sharedManager] isSpringFestival]) {
        // 春节期间
        // 首页
        _homeVC = [HomeViewController new];
        [self addChildVC:_homeVC Title:@"" image:@"nian_jin_normal" selectedImage:@"nian_jin_heighted" Tag:1];
        // 消息
        _chatListVC = [[ChatListViewController alloc] init];
        [self addChildVC:_chatListVC Title:@"消息" image:@"nian_ji_normal" selectedImage:@"nian_ji_height" Tag:2];
        [_chatListVC networkChanged:_connectionState];
        // 通讯录
        _contactVC = [[ContactListViewController alloc] init];
        [self addChildVC:_contactVC Title:@"通讯录" image:@"nian_bao_normal" selectedImage:@"nian_bao_heighted" Tag:3];
        // 我
        _woVC = [WoViewController new];
        [self addChildVC:_woVC Title:@"我" image:@"nian_chun_normal" selectedImage:@"nian_chun_heighted" Tag:4];
        _woVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }else{
        // 平常时间
        // 首页
        _homeVC = [HomeViewController new];
        [self addChildVC:_homeVC Title:@"我的影楼" image:@"btn_yingyong" selectedImage:@"btn_yingyong_dj" Tag:1];
        // 消息
        _chatListVC = [[ChatListViewController alloc] init];
        [self addChildVC:_chatListVC Title:@"消息" image:@"btn_xiaoxi" selectedImage:@"btn_xiaoxi_dj" Tag:2];
        [_chatListVC networkChanged:_connectionState];
        // 通讯录
        _contactVC = [[ContactListViewController alloc] init];
        [self addChildVC:_contactVC Title:@"通讯录" image:@"btn_tongxunlu" selectedImage:@"btn_tongxunlu_dj" Tag:3];
        // 我
        _woVC = [WoViewController new];
        [self addChildVC:_woVC Title:@"我" image:@"btn_-wode" selectedImage:@"btn_-wode_dj" Tag:4];
        _woVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    
    
}

#pragma mark - 添加子控制器
- (void)addChildVC:(UIViewController *)childVC Title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage Tag:(NSInteger)tag
{
    
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.tag = tag;
    
    [self.tabbarArray addObject:childVC.tabBarItem];
    
    //    childVC.tabBarItem.imag
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttres = [NSMutableDictionary dictionary];
    textAttres[NSFontAttributeName] = [UIFont systemFontOfSize:9];
    if ([[YLZGDataManager sharedManager] isSpringFestival]) {
        textAttres[NSForegroundColorAttributeName] = SpringColor;
    }else{
        textAttres[NSForegroundColorAttributeName] = RGBACOLOR(191, 191, 191, 1);
    }
    
    NSMutableDictionary *selectTextAttres = [NSMutableDictionary dictionary];
    selectTextAttres[NSForegroundColorAttributeName] = MainColor;
    selectTextAttres[NSFontAttributeName] = [UIFont systemFontOfSize:9];

    [childVC.tabBarItem setTitleTextAttributes:textAttres forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:selectTextAttres forState:UIControlStateSelected];
    
    childVC.title = title;
    
    HomeNavigationController *normalNav = [[HomeNavigationController alloc]initWithRootViewController:childVC];
    [self addChildViewController:normalNav];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([[YLZGDataManager sharedManager] isSpringFestival]) {
        for (UITabBarItem *otherItem in self.tabbarArray) {
            if (otherItem.tag == 1) {
                otherItem.title = @"我的影楼";
            }else if (otherItem.tag == 2){
                otherItem.title = @"消息";
            }else if (otherItem.tag == 3){
                otherItem.title = @"通讯录";
            }else{
                otherItem.title = @"我";
            }
        }
        item.title = @"";
    }
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    KGLog(@"userInfo=%@",userInfo);
    [self showSuccessTips:@"接收到消息了"];
}
- (void)jumpToChatList:(NSDictionary *)dict
{
    KGLog(@"dict = %@",dict);
}
#pragma mark - 未处理的请求
- (void)loadUntreatedApplyCount
{
    [[YLZGDataManager sharedManager] loadUnApplyApplyFriendArr:^(NSMutableArray *array) {
        NSInteger unreadCount = array.count;
        [_contactVC reloadApplyViewWithBadgeNumber:unreadCount];
        if (_contactVC) {
            if (unreadCount > 0) {
                _contactVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
                // 缓存
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:[NSString stringWithFormat:@"%d",(int)(array.count)] forKey:UDUnApplyCount];
                [userDefault synchronize];
            }else{
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:[NSString stringWithFormat:@"%d",(int)(array.count)] forKey:UDUnApplyCount];
                [userDefault synchronize];
                _contactVC.tabBarItem.badgeValue = nil;
            }
        }
    }];
}
#pragma mark - 未读消息统计
- (void)loadUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unreadCount];
}
#pragma mark - 收到推送时的声音
- (void)playSoundAndVibration
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    
    EMMessageBody *messageBody = message.body;
    NSString *messageStr = nil;
    switch (messageBody.type) {
        case EMMessageBodyTypeText:
        {
            messageStr = ((EMTextMessageBody *)messageBody).text;
            messageStr = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:messageStr];
        }
            break;
        case EMMessageBodyTypeImage:
        {
            messageStr = @"[图片]";
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            messageStr = @"[位置]";
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            messageStr = @"[语音]";
        }
            break;
        case EMMessageBodyTypeVideo:{
            messageStr = @"[视频]";
        }
            break;
        default:
            break;
    }
    
    
    __weak __block NSString *title;
    if (message.chatType == EMChatTypeChat) {
        // 单聊
        [[YLZGDataManager sharedManager] getOneStudioByUserName:message.from Block:^(ContactersModel *model) {
            NSString *name = model.nickname.length>=1 ? model.nickname : model.realname;
            title = [NSString stringWithFormat:@"%@：%@",name,messageStr];
        }];
    }else{
        
        [[YLZGDataManager sharedManager] getOneStudioByUserName:message.from Block:^(ContactersModel *model) {
            NSString *name = model.nickname.length>=1 ? model.nickname : model.realname;
            title = [NSString stringWithFormat:@"群聊->%@：%@",name,messageStr];
        }];
        
    }
    
    //发送本地推送

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    //#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    notification.alertBody = title;
    notification.alertBody = [[NSString alloc] initWithFormat:@"%@", notification.alertBody];
    
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)networkChanged:(EMConnectionState)connectionState;
{
    _connectionState = connectionState;
    [_homeVC networkChanged:connectionState];
    [_chatListVC networkChanged:connectionState];
}

- (void)PushToChatVC:(NSNotification *)noti
{
    
    self.selectedIndex = 1;
    self.title = @"消息";
    if ([noti.object intValue] == 1) {
        // 单聊
        ContactersModel *model = [ContactersModel mj_objectWithKeyValues:noti.userInfo];
        ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:model.name conversationType:EMConversationTypeChat];
        chatVC.contactModel = model;
        [_chatListVC.navigationController pushViewController:chatVC animated:NO];
    }else{
        // 群聊
        YLGroup *model = [YLGroup mj_objectWithKeyValues:noti.userInfo];
        ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:model.gid conversationType:EMConversationTypeGroupChat];
        chatVC.groupModel = model;
        [_chatListVC.navigationController pushViewController:chatVC animated:NO];
    }
    
}

- (void)dealloc
{
//    [YLNotificationCenter removeObserver:self forKeyPath:HXSetupUntreatedApplyCount];
//    [YLNotificationCenter removeObserver:self forKeyPath:HXSetupUnreadMessageCount];
//    [YLNotificationCenter removeObserver:self forKeyPath:HXRePushToChat];
    
    
    [YLNotificationCenter removeObserverBlocksForKeyPath:HXSetupUntreatedApplyCount];
    [YLNotificationCenter removeObserverBlocksForKeyPath:HXSetupUnreadMessageCount];
    [YLNotificationCenter removeObserverBlocksForKeyPath:HXRePushToChat];
    
}

- (NSMutableArray *)tabbarArray
{
    if (!_tabbarArray) {
        _tabbarArray = [NSMutableArray array];
    }
    return _tabbarArray;
}

@end
