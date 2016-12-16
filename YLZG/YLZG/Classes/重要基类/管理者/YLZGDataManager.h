//
//  YLZGDataManager.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HuanxinContactManager.h"
#import "StudioContactManager.h"


typedef void (^ApplyFriend)(NSMutableArray * array);

typedef void (^NoParamBlock)();

typedef void (^StuduoModelBlock)(ContactersModel *model);

typedef void(^ShareUrlBlock)(NSString *url);

/******** 收录一些重要的数据管理 *******/
@interface YLZGDataManager : NSObject


/** 单例初始化 */
+ (instancetype)sharedManager;
/** 获取未处理的申请通知 */
- (void)loadUnApplyApplyFriendArr:(ApplyFriend)ApplyFriendArr;

/** 把群组信息存进数据库 */
- (void)saveGroupInfoWithBlock:(NoParamBlock)reloadTable;
/** 获取本地通讯录全部好友信息 */
- (NSMutableArray *)getAllFriendInfo;
/** 通过一个影楼ID获取一个用户的信息 */
- (void)getOneStudioByUserName:(NSString *)userName Block:(StuduoModelBlock)modelBlock;
/** 通过一个影楼UID获取一个用户的信息 */
- (void)getOneStudioByUID:(NSString *)userID Block:(StuduoModelBlock)modelBlock;
/** 获取分享链接 */
- (void)getShareUrlCompletion:(ShareUrlBlock)shareURL;

/**
 是否为春节期间

 @return BOOL
 */
- (BOOL)isSpringFestival;


@end
