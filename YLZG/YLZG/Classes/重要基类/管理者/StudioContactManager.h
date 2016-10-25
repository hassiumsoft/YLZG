//
//  StudioContactManager.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColleaguesModel.h"

/***************** 通讯录好友[仅限影楼同事]离线缓存数据库 ****************/


@interface StudioContactManager : NSObject

/**
 *  保存一个影楼部门通讯录好友到数据库
 *
 *  @param studiosModel 通讯录好友模型
 *
 *  @return 是否成功
 */
+ (BOOL)saveAllStudiosContactsInfo:(ColleaguesModel *)studiosModel;

/**
 *  获取全部影楼同事信息
 *
 *  @return 好友数组
 */
+ (NSMutableArray *)getAllStudiosContactsInfo;



/**
 *  删除全部数据，不删除数据库
 *
 *  @return 是否成功
 */
+ (BOOL)deleteAllInfo;

@end
