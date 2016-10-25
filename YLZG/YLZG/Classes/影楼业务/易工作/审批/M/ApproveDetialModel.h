//
//  ApproveDetialModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApproveDetialModel : NSObject

/** 这条申请的ID */
@property (copy,nonatomic) NSString *id;
/** 申请人的UID */
@property (copy,nonatomic) NSString *uid;
/** 类型：请假2、外出3、物品4、通用1 */
@property (assign,nonatomic) NSInteger kind;
/** 审批时间 */
@property (copy,nonatomic) NSString *appro_time;
/** 审批人头像 */
@property (copy,nonatomic) NSString *appro_head;
/** 申请人头像 */
@property (copy,nonatomic) NSString *sply_head;
/** 店铺ID */
@property (copy,nonatomic) NSString *sid;

/** 开始时间-请假、外出 */
@property (assign,nonatomic) NSTimeInterval start;
/** 结束时间 */
@property (assign,nonatomic) NSTimeInterval finish;

/** 类型--请假 */
@property (copy,nonatomic) NSString *type;
/** 申请时间 */
@property (assign,nonatomic) NSTimeInterval sply_time;
/** 审批人名字 */
@property (copy,nonatomic) NSString *appro_nickname;
/** iOS是否已读 */
@property (copy,nonatomic) NSString *ios_is_read;
/** 原因、说明 */
@property (copy,nonatomic) NSString *reason;
/** 审批人的ID */
@property (copy,nonatomic) NSString *approver;
/** 申请人的昵称 */
@property (copy,nonatomic) NSString *sply_nickname;

/** 审批意见-“审批人的话” */
@property (copy,nonatomic) NSString *appro_opinion;
/** 外出标题 */
@property (copy,nonatomic) NSString *title;
/** 外出时间 */
@property (copy,nonatomic) NSString *how_long;
/** 外出的理由 */
@property (copy,nonatomic) NSString *content;
/** 状态 1：已通过 0：等待审核 2：审核被拒绝 */
@property (assign,nonatomic) NSInteger status;

/** 物品领用-理由 */
@property (copy,nonatomic) NSString *details;
/** 物品领用-物品用处 */
@property (copy,nonatomic) NSString *usages;
/** 物品名称 */
@property (copy,nonatomic) NSString *items;
/** 物品数量 */
@property (assign,nonatomic) NSInteger nums;



@end
