//
//  HuanxinContactManager.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactersModel.h"


/***************** 通讯录好友[仅限环信好友]离线缓存数据库 ****************/

@interface HuanxinContactManager : NSObject

/**
 *  保存一个环信通讯录好友到数据库
 *
 *  @param contactModel 通讯录好友模型
 *
 *  @return 是否成功
 */
+ (BOOL)saveAllHuanxinContactsInfo:(ContactersModel *)contactModel;

/**
 *  获取全部环信好友
 *
 *  @return 好友数组
 */
+ (NSMutableArray *)getAllHuanxinContactsInfo;


/**
 *  通过登录号来获取
 *
 *  @param userName 对方登录名
 *
 *  @return 用户模型
 */
+ (ContactersModel *)getOneFriendByUserName:(NSString *)userName;


/**
 *  删除全部数据，不删除数据库
 *
 *  @return 是否成功
 */
+ (BOOL)deleteAllInfo;

@end

