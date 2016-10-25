//
//  ApproveModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApproveModel : NSObject

/** 状态 */
@property (assign,nonatomic) NSInteger status;
/** 该条审批的ID */
@property (copy,nonatomic) NSString *id;
/** 审批类型 */
@property (assign,nonatomic) int kind;
/** 申请时间 */
@property (assign,nonatomic) NSTimeInterval sply_time;

/** 申请人的ID */
@property (copy,nonatomic) NSString *uid;
/** 申请人名称 */
@property (copy,nonatomic) NSString *sply_nickname;
/** 申请人头像 */
@property (copy,nonatomic) NSString *sply_head;


/** 审批人ID */
@property (copy,nonatomic) NSString *approver;
/** 审批人名称 */
@property (copy,nonatomic) NSString *appro_nickname;
/** 审批人头像 */
@property (copy,nonatomic) NSString *appro_head;







@end
