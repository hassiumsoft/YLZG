//
//  TaskDetialDynamicModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/24.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/********* 动态记录 *********/

@interface TaskDetialDynamicModel : NSObject

/** 动态内容 */
@property (copy,nonatomic) NSString *content;
/** 任务ID */
@property (copy,nonatomic) NSString *id;
/** 动态创建时间 */
@property (assign,nonatomic) NSTimeInterval time;
/** 栏目类型 1任务 2文件 */
@property (assign,nonatomic) int type;


@end
