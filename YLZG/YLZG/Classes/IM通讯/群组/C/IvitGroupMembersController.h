//
//  IvitGroupMembersController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface IvitGroupMembersController : SuperViewController

/** 选中的成员数组 */
@property (copy,nonatomic) void (^MemebersBlock)(NSArray *members);

/** 选中的项目成员 */
@property (copy,nonatomic) void (^SeletcMemberBlock)(NSArray *selectMem);

@end
