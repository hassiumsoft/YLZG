//
//  TodayOrderModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayOrderModel : NSObject

/** 订单ID */
@property (copy,nonatomic) NSString *id;
/** 顾客 */
@property (copy,nonatomic) NSString *guest;
/** 联系电话 */
@property (copy,nonatomic) NSString *phone;
/** 套系 */
@property (nonatomic, copy) NSString * set;
/** 价格 */
@property (nonatomic, copy) NSString * price;
/** 门市(开单员工) */
@property (nonatomic, copy) NSString * store;
/** 日期 */
@property (nonatomic, copy) NSString * date;


@end
