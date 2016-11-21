//
//  TaskProduceListModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/18.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskProduceListModel : NSObject

/** 项目ID */
@property (copy,nonatomic) NSString *id;
/** 创建者ID */
@property (copy,nonatomic) NSString *create_user;
/** 创建者ID */
@property (copy,nonatomic) NSString *uid;
/** 项目名称 */
@property (copy,nonatomic) NSString *name;
/** 创建时间 */
@property (assign,nonatomic) NSTimeInterval create_at;

@end
