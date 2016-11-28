//
//  TaskDetialModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
#import "TaskDetialCareModel.h"
#import "TaskDetialCheckModel.h"
#import "TaskDetialDiscussModel.h"
#import "TaskDetialDynamicModel.h"


/************** 任务详情 *****************/

@interface TaskDetialModel : NSObject

/** 任务ID */
@property (copy,nonatomic) NSString *id;
/** 任务创建时间 */
@property (copy,nonatomic) NSString *create_at;
/** 完成（截止）时间 */
@property (assign,nonatomic) NSTimeInterval deadline;
/** 删除时间： 0未删除  、大于0 已删除 */
@property (assign,nonatomic) int delete_at;
/** 负责人头像 */
@property (copy,nonatomic) NSString *head;
/** 任务名称 */
@property (copy,nonatomic) NSString *name;
/** 负责人昵称 */
@property (copy,nonatomic) NSString *nickname;
/** 任务状态  0 进行中  1完成 */
@property (assign,nonatomic) int status;
/** 负责人UID */
@property (copy,nonatomic) NSString *uid;

/** 检查项 */
@property (copy,nonatomic) NSArray *check;
/** 关注者 */
@property (copy,nonatomic) NSArray *care;
/** 讨论记录 */
@property (copy,nonatomic) NSArray *discuss;
/** 动态记录 */
@property (copy,nonatomic) NSArray *dynamic;


@end
