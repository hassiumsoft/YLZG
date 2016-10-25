//
//  UserInfoManager.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"


/********* 用FMDB对用户信息进行本地增删查改 ********/


@interface UserInfoManager : NSObject

/**
 *  第一次智诚服务器后保存用户信息
 *
 *  @param model 用户模型
 */
+ (void)saveInfoToSandBox:(UserInfoModel *)model;

/**
 *  返回用户所有的数据
 *
 *  @return 用户模型
 */
+ (UserInfoModel *)getUserInfo;

/**
 *  更新某条信息
 *
 *  @param key   ⚠️用户表格里的字段名。必须参照建表语句⚠️
 *  @param value ⚠️字段对应的值，需要更新的内容⚠️
 *
 *  @return 修改是否成功
 */
+ (BOOL)updataUserInfoWithKey:(NSString *)key Value:(NSString *)value;

/**
 *  先删除某条数据，再保存新的
 *
 *  @param indexID 是否成功
 */
+ (BOOL)deleteOneDataInfo:(NSInteger)indexID;


/**
 *  删除全部数据
 *
 *  @return 是否成功
 */
+ (BOOL)deleteAllData;





@end

