//
//  DakaManager.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DakaManager : NSObject


/**
 单例初始化

 @return 自己
 */
+ (instancetype)sharedManager;


/**
 获取当前wifi名称

 @return WiFi名称
 */
- (NSString *)getWifiName;

/**
 是否在可打卡范围内

 @param locationArr 位置信息模型
 @return BOOL
 */
- (BOOL)isInArea:(NSArray *)locationArr;

@end
