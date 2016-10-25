//
//  IviteMemberViewController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "YLGroup.h"


typedef NS_ENUM(NSInteger,AddDeleteMembers) {
    AddMemberType,  // 邀请成员
    DeleteMemberType  // 踢出成员
};

@interface IviteMemberViewController : SuperViewController


/** 已经在群里的朋友 */
@property (copy,nonatomic) NSArray *groupArr;
/** 加人还是踢人 */
@property (assign,nonatomic) AddDeleteMembers type;
/** 群组模型 */
@property (strong,nonatomic) YLGroup *groupModel;

/** 添加或踢出的成员数组回调 */
@property (copy,nonatomic) void (^AddMembersBlock)(NSArray *memberArr);

@end
