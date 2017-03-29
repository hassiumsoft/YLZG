//
//  SearchOrderModel.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/10.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchOrderModel : NSObject

/** 订单ID */
@property (copy,nonatomic) NSString *tradeid;
/** ID */
@property (copy,nonatomic) NSString *tradeID;
/** 电话 */
@property (copy,nonatomic) NSString *maphone;
/** 门市 */
@property (copy,nonatomic) NSString *store;
/** 产品相关 */
@property (copy,nonatomic) NSString *packages;


/** 套系名称 */
@property (copy,nonatomic) NSString *set;
/** 价格 */
@property (copy,nonatomic) NSString *price;

@end
