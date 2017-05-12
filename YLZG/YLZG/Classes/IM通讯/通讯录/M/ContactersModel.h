//
//  ContactersModel.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/7.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import <Foundation/Foundation.h>


/********* 通讯录好友模型 ***********/

@interface ContactersModel : NSObject


/** 用户ID */
@property (copy,nonatomic) NSString *uid;
/** 店铺的ID */
@property (copy,nonatomic) NSString *sid;
/** 登录名 */
@property (copy,nonatomic) NSString *name;
/** 昵称 */
@property (copy,nonatomic) NSString *nickname;
/** realname */
@property (copy,nonatomic) NSString *realname;
/** QQ */
@property (copy,nonatomic) NSString *qq;
/** 电话 */
@property (copy,nonatomic) NSString *mobile;
/** 地址 */
@property (copy,nonatomic) NSString *location;
/** 头像 */
@property (copy,nonatomic) NSString *head;
/** 性别 */
@property (copy,nonatomic) NSString *gender;
/** 部门 */
@property (copy,nonatomic) NSString *dept;
/** 生日时间戳 */
@property (copy,nonatomic) NSString *birth;

/** 是否被选中 */
@property (assign,nonatomic) BOOL isSelected;
/** 索引 */
@property (assign,nonatomic) NSInteger index;

/** 邀请人进群时的状态 */
@property (assign,nonatomic) BOOL status;


@end
