//
//  ProduceDetialModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProduceFileModel.h"
#import "ProduceMemberModel.h"
#import "ProduceTaskModel.h"
#import "ProduceDiscussModel.h"

@interface ProduceDetialModel : NSObject

/** 创建者 */
@property (copy,nonatomic) NSString *create_user;
/** 项目名称 */
@property (copy,nonatomic) NSString *name;
/** 店铺ID */
@property (copy,nonatomic) NSString *sid;

/** 成员 */
@property (copy,nonatomic) NSArray *member;
/** 项目任务 */
@property (copy,nonatomic) NSArray *task;
/** 项目文件 */
@property (copy,nonatomic) NSArray *file;
/** 项目评论 */
@property (copy,nonatomic) NSArray *discuss;



@end
