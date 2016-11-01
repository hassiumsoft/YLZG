//
//  KaoqinModel.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/6/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GudingPaibanModel.h"
#import "BanciModel.h"
#import "LocationsModel.h"

/************ 考勤里的大模型,包含6个嵌套数组 **************/

@interface KaoqinModel : NSObject

/** 考勤组ID */
@property (copy,nonatomic) NSString *id;
/** 考勤组名称 */
@property (copy,nonatomic) NSString *name;
/** 考勤组负责人 */
@property (copy,nonatomic) NSArray *group_admin;
/** 成员数组 */
@property (copy,nonatomic) NSArray *group_users;

/** 固定班制 */
@property (copy,nonatomic) NSArray *rule1; // PaibanModel
/** 排班制 */
@property (copy,nonatomic) NSArray *rule2; // PaibanModel

/** wifi数组 */
@property (copy,nonatomic) NSArray *routers;
/** 地址数组 */
@property (copy,nonatomic) NSArray *locations; // LocationsModel

/** 有设置好的班次 */
@property (copy,nonatomic) NSArray *classes;  // BanciModel

/** sid */
@property (copy,nonatomic) NSString *sid;
/** 类型：固定班制还是排班制 */
@property (copy,nonatomic) NSString *type;
/** 有效范围 */
@property (copy,nonatomic) NSString *privilege_meters;


@end
