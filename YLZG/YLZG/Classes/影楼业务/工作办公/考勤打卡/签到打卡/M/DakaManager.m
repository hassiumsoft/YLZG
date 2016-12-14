//
//  DakaManager.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "DakaManager.h"
#import "CheckInOnModel.h"
#import "CheckInOffModel.h"
#import "TodayDakaLocationsModel.h"
#import <SystemConfiguration/CaptiveNetwork.h>



@interface DakaManager ()



@end


@implementation DakaManager



+ (instancetype)sharedManager
{
    static DakaManager *_dakaManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dakaManager = [[DakaManager alloc] init];
    });
    return _dakaManager;
}

- (BOOL)isInArea:(NSArray *)locationArr
{
    BOOL isInArea = NO;
    for (int i = 0; i < locationArr.count; i++) {
        TodayDakaLocationsModel *locationModel = locationArr[i];
        // 只要有一个在范围就可以提示能打卡
        
    }
    
    return isInArea;
}

#pragma mark -获取当前的wifi名字
- (NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}



@end
