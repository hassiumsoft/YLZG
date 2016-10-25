//
//  NoticeManager.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeModel.h"


/********* 公告的离线缓存 **********/
@interface NoticeManager : NSObject


/**
 保存全部公告
 
 @param model 公告模型

 @return 是否成功
 */
+ (BOOL)saveAllNoticeWithNoticeModel:(NoticeModel *)model;


/**
 获取全部公告数据

 @return sl
 */
+ (NSMutableArray *)getAllNoticeInfo;

/**
 删除全部数据，不删除数据库

 @return 阿卡卡
 */
+ (BOOL)deleteAllInfo;


@end
