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
#import "YLGroup.h"


typedef void (^ApplyFriend)(NSMutableArray * array);

typedef void (^NoParamBlock)();

typedef void (^StuduoModelBlock)(ContactersModel *model);

typedef void(^ShareUrlBlock)(NSString *url);

/******** 收录一些重要的数据管理 *******/
@interface YLZGDataManager : NSObject


/** 单例初始化 */
+ (instancetype)sharedManager;

/** 登录 */
- (void)loginWithUserName:(NSString *)userName PassWord:(NSString *)passWord Success:(void (^)())success Fail:(void (^)(NSString *errorMsg))fail;

/** 获取未处理的申请通知 */
- (void)loadUnApplyApplyFriendArr:(ApplyFriend)ApplyFriendArr;

/** 更新群组信息缓存 */
- (void)updataGroupInfoWithBlock:(NoParamBlock)reloadTable;
/** 获取本地通讯录全部好友信息 */
- (NSMutableArray *)getAllFriendInfo;
/** 通过一个影楼ID获取一个用户的信息 */
- (void)getOneStudioByUserName:(NSString *)userName Block:(StuduoModelBlock)modelBlock;
/** 获取并保存通讯录好友 */
- (void)refreshContactersSuccess:(void (^)(NSArray *userArray))success Fail:(void (^)(NSString *errorMsg))fail;
/** 根据昵称模糊查询对方信息 */
- (void)searchUserByName:(NSString *)nickName Success:(void (^)(NSArray *userArray))Success Fail:(void (^)(NSString *errorMsg))fail;
/** 通过一个影楼UID获取一个用户的信息 */
- (void)getOneStudioByUID:(NSString *)userID Block:(StuduoModelBlock)modelBlock;
/** 邀请成员进群时，那些可以邀请 */
- (void)getIvitersByGroupID:(NSString *)groupID Success:(void (^)(NSArray *memberArray))success Fail:(void (^)(NSString *errorMsg))fail;
/** 获取分享链接 */
- (void)getShareUrlCompletion:(ShareUrlBlock)shareURL;
/** 发起群聊：建立群组 */
- (void)createGroupWithMembers:(NSArray *)memberArray Success:(void (^)(YLGroup *groupModel))success Fail:(void (^)(NSString *errorMsg))fail;


/**
 是否为春节期间

 @return BOOL
 */
- (BOOL)isSpringFestival;


@end
