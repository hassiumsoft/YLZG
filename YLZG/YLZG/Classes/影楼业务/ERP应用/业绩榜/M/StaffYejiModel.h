//
//  StaffYejiModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/******* 员工业绩模型 *******/
@interface StaffYejiModel : NSObject

/** 头像 */
@property (copy,nonatomic) NSString *head;
/** 积分 */
@property (copy,nonatomic) NSString *record;
/** 员工名字 */
@property (copy,nonatomic) NSString *staff;
/** 排名 */
@property (assign,nonatomic) int rank;

@end
