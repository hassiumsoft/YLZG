//
//  TaskListModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>


/******************我关注的任务*****************/

@interface TaskListModel : NSObject


/** 是否是我负责 */
@property (assign,nonatomic) BOOL isMyManager;

/** 关注者ID */
@property (copy,nonatomic) NSString *careuid;
/** 创建时间 */
@property (assign,nonatomic) NSTimeInterval create_at;
/** 创建者UID */
@property (copy,nonatomic) NSString *create_user;
/** 完成（截止）时间 */
@property (assign,nonatomic) NSTimeInterval deadline;
/** 删除时间： 0未删除  、大于0 已删除 */
@property (copy,nonatomic) NSString *delete_at;
/** 负责人头像 */
@property (copy,nonatomic) NSString *head;
/** 任务ID */
@property (copy,nonatomic) NSString *id;
/** 任务名称 */
@property (copy,nonatomic) NSString *name;
/** 负责人昵称 */
@property (copy,nonatomic) NSString *nickname;
/** 项目ID */
@property (copy,nonatomic) NSString *pid;
/** 项目名称 */
@property (copy,nonatomic) NSString *project;
/** 任务状态  0 进行中  1完成 */
@property (assign,nonatomic) int status;
/** 负责人ID */
@property (copy,nonatomic) NSString *uid;


@end
