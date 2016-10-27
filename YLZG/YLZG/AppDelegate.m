//
//  AppDelegate.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AppDelegate.h"
#import "SuperViewController.h"
#import "ZCAccountTool.h"
#import <UMMobClick/MobClick.h>
#import <JPUSHService.h>
#import "HomeNavigationController.h"
#import "LoginViewController.h"
#import "ZCAccountTool.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "HTTPManager.h"
#import "HomeTabbarController.h"
#import "YLZGChatManager.h"
#import "UserInfoManager.h"
#import <MJExtension.h>



#define MENU_ID [[NSUserDefaults standardUserDefaults] objectForKey:@"MENUID"]

@interface AppDelegate ()<BMKGeneralDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupSDKWithOptions:launchOptions];
    [self chooseRootViewControllerWithVersion];
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)chooseRootViewControllerWithVersion
{
    
    [YLNotificationCenter addObserver:self selector:@selector(switchRootViewController:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    // 需要再登录一遍
    [self reLoginAction];
    [self switchRootViewController:nil];
}
- (void)reLoginAction
{
    ZCAccount *account = [ZCAccountTool account];
    if (!account) {
        KGLog(@"归档为空，请重新登录。");
        return;
    }
    NSString *deviceName = [UIDevice currentDevice].name;
    CGFloat deviceVersion = [[UIDevice currentDevice].systemVersion floatValue];
    
    NSString *deviceInfo = [NSString stringWithFormat:@"%@_%g",deviceName,deviceVersion];
    deviceInfo = [deviceInfo stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *url = [NSString stringWithFormat:YLLoginURL,account.username,account.password,deviceInfo];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // 更新用户信息模型
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:result];
            [UserInfoManager deleteAllData];
            [UserInfoManager saveInfoToSandBox:model];
            [MobClick profileSignInWithPUID:model.username];
        }else{
            NSString *msg = [NSString stringWithFormat:@"%@-建议退出再登录",message];
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
#pragma mark - 登录状态改变了
- (void)switchRootViewController:(NSNotification *)note
{
    NSString *userName = [[EMClient sharedClient] currentUsername];
    
    if (userName.length) {
        // 自动登录成功
        self.isShowNewPage = YES;
        HomeTabbarController *tabBarVC = [[HomeTabbarController alloc] init];
        HomeNavigationController *nav = [[HomeNavigationController alloc]initWithRootViewController:tabBarVC];
        [YLZGChatManager sharedManager].tabbarVC = tabBarVC;
        [[YLZGChatManager sharedManager] asyncPushOptions];
        [[YLZGChatManager sharedManager] asyncConversationFromDB];
        self.window.rootViewController = nav;
    }else{
        // 自动登录失败<分第一次登录和被动登录>
        self.isShowNewPage = NO;
        [YLZGChatManager sharedManager].tabbarVC = nil;
        [self goToLoginViewController:note];
    }
    
}

- (void)goToLoginViewController:(NSNotification *)note
{
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    HomeNavigationController *nav = [[HomeNavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
}

#pragma mark - 初始化各个第三方库
- (void)setupSDKWithOptions:(NSDictionary *)launchOptions
{
    // 友盟
    UMConfigInstance.appKey = UMengKey;
    UMConfigInstance.eSType = E_UM_NORMAL;
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setCrashReportEnabled:YES];
    ZCAccount *account = [ZCAccountTool account];
    if (account) {
        [MobClick profileSignInWithPUID:account.username];
    }
    // 极光推送
    NSString *apnsCertName = nil;
    BOOL push_isProdution = YES;
#if DEBUG
    apnsCertName = @"push_dev"; // chatdemoui_dev
    push_isProdution = NO; // 开发环境，不推送
#else
    apnsCertName = @"push_store";  // chatdemoui
    push_isProdution = YES; // 生产环境，推送
#endif
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey channel:@"" apsForProduction:push_isProdution];
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        // 这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            [self goToMssageViewControllerWith:remoteNotification];
        }
    }
    
    // 百度地图
    BMKMapManager *mapManager = [[BMKMapManager alloc]init];
    [mapManager start:BaiduMapSecret generalDelegate:self];
    
    // 环信
    _connectionState = EMConnectionConnected;
    EMOptions *options = [EMOptions optionsWithAppkey:HXAppKey];
    options.apnsCertName = apnsCertName;
    options.enableConsoleLog = YES;
    options.isAutoLogin = YES;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    
    // 环信红包SDK？
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_homeTabbar) {
        [_homeTabbar didReceiveLocalNotification:notification];
    }
}
#pragma mark -app在运行的时候触发的方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self goToMssageViewControllerWith:userInfo];
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


// 点击通知跳转页面
- (void)goToMssageViewControllerWith:(NSDictionary*)dic{
    NSDictionary * dict = nil;
    if ([dic[@"action"] intValue] == 1) {
        dict = @{@"num" : @"1"};
        
    }else if ([dic[@"action"] intValue] == 2) {
        if ([dic[@"type"] intValue] == 1) {
            
            dict = @{@"num" : @"2"};
            
        }else if ([dic[@"type"] intValue] == 2) {
            dict = @{@"num" : @"3"};
        }
    }else
        if(_homeTabbar) {
            [_homeTabbar jumpToChatList:dic];
        }
    if ([MENU_ID isEqualToString:@"0"])
    {
        [YLNotificationCenter postNotificationName:@"PUSH" object:dict];
    }
}
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[EMClient sharedClient] bindDeviceToken:deviceToken];
        [[EMClient sharedClient] registerForRemoteNotificationsWithDeviceToken:deviceToken completion:^(EMError *aError) {
            if (aError) {
                KGLog(@"推送aError = %@",aError.errorDescription);
            }
        }];
        [JPUSHService registerDeviceToken:deviceToken];
    });
}
// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册推送失败");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end
