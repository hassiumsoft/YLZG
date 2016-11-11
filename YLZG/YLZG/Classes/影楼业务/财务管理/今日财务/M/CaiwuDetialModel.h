//
//  CaiwuDetialModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaiwuDetialModel : NSObject

/** 客户姓名 */
@property (copy,nonatomic) NSString *customer;
/** 开单人 */
@property (copy,nonatomic) NSString *drawer;
/** 收款金额 */
@property (copy,nonatomic) NSString *money;
/** 订单号 */
@property (copy,nonatomic) NSString *order;
/** 收款人员 */
@property (copy,nonatomic) NSString *payee;
/** 收款时间 */
@property (copy,nonatomic) NSString *time;
/** 收款类型 */
@property (copy,nonatomic) NSString *type;

@end
