//
//  OfflineDataManager.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/20.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <Foundation/Foundation.h>


/********* 离线数据管理者 **********/

@interface OfflineDataManager : NSObject


/**
 *  保存离线订单
 *
 *  @param parameter 订单参数
 */
+ (void)saveToSandBox:(NSDictionary *)parameter;

/**
 *  删除某个订单
 *
 *  @param index 在数据库中的ID
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteOrderAtIndex:(NSInteger)index;

/**
 *  从沙盒中取得全部离线订单数据
 *
 *  @return 全部数据
 */
+ (NSArray *)getAllOffLineOrderFromSandBox;

/**
 *  本地通知
 *
 *  @param alertTime 触发本地通知的时间
 */
+ (void)registerLocalNotification:(NSInteger)alertTime Count:(int)count;

@end
