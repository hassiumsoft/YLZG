//
//  TaskDetialCheckModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/24.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskDetialCheckModel : NSObject

/** 内容 */
@property (copy,nonatomic) NSString *content;
/** 创建时间 */
@property (assign,nonatomic) NSTimeInterval create_at;
/** 检查项ID */
@property (copy,nonatomic) NSString *id;
/** 状态 0进行中 1完成 */
@property (assign,nonatomic) int status;
/** 任务ID */
@property (copy,nonatomic) NSString *tid;

@end
