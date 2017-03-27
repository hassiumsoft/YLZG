//
//  UserInfoManager.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "ZCAccountTool.h"




@interface UserInfoManager : NSObject

/**
 单例初始化
 
 @return UserInfoManager
 */
+ (instancetype)sharedManager;

/**
 保存用户全部信息
 
 @param userModel 用户信息模型
 @param success 保存成功
 @param fail 保存失败
 */
- (void)saveUserInfo:(UserInfoModel *)userModel Success:(void (^)())success Fail:(void (^)(NSString *errorMsg))fail;


/**
 获取用户全部信息
 
 @return UserInfoModel
 */
- (UserInfoModel *)getUserInfo;

/**
 更新某条信息
 
 @param key FYQConstKey里的U开头的Key
 @param value 新值
 */
- (void)updateWithKey:(NSString *)key Value:(NSString *)value;

/**
 删除信息缓存
 */
- (void)removeDataSave;

@end

