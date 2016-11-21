//
//  TaskTaskModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskTaskModel : NSObject



/** 任务ID */
@property (copy,nonatomic) NSString *id;
/** 状态状态 0进行中 1完成 */
@property (assign,nonatomic) int status;
/** 所属项目名称 */
@property (copy,nonatomic) NSString *project;
/** 所属项目ID */
@property (copy,nonatomic) NSString *pid;
/** 任务名称 */
@property (copy,nonatomic) NSString *name;

/** 创建时间 */
@property (assign,nonatomic) NSTimeInterval create_at;
/** 创建人uid */
@property (copy,nonatomic) NSString *create_user;
/** 完成（截止时间） */
@property (copy,nonatomic) NSString *deadline;
/** 删除时间： 0未删除  、大于0 已删除 */
@property (assign,nonatomic) int delete_at;

/** 负责人头像 */
@property (copy,nonatomic) NSString *head;
/** 负责人昵称 */
@property (copy,nonatomic) NSString *nickname;
/** 负责人uid */
@property (copy,nonatomic) NSString *uid;


@end
