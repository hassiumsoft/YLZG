//
//  TodayFinaceModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayFinaceModel : NSObject


/** 二销 */
@property (copy,nonatomic) NSString *tsell;
/** 补款 */
@property (copy,nonatomic) NSString *extra;
/** 定金 */
@property (copy,nonatomic) NSString *deposit;
/** 订单 */
@property (copy,nonatomic) NSString *trade;
/** 其他 */
@property (copy,nonatomic) NSString *other;

/** 收入 */
@property (copy,nonatomic) NSString *income;
/** 支出 */
@property (copy,nonatomic) NSString *expend;
/** 净收入 */
@property (copy,nonatomic) NSString *netin;



@end
