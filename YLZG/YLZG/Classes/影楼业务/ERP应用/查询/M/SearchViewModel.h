//
//  SearchViewModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchViewModel : NSObject

@property (assign,nonatomic) int multi;

/** 客人姓名 */
@property (nonatomic, copy) NSString * guestname;
/** 电话 */
@property (nonatomic, copy) NSString * phone;
@property (copy,nonatomic) NSString *maphone;// muti=0
/** 订单号 */
@property (nonatomic, copy) NSString * tradeID;
/** 只有一个订单是的订单号 */
@property (copy,nonatomic) NSString *tradeid;// muti=0

@property (copy,nonatomic) NSString *baby;

@property (copy,nonatomic) NSString *balance;// muti=0

@property (copy,nonatomic) NSString *packages;

/** 负责人 */
@property (copy,nonatomic) NSString *store;
/** 套系名称 */
@property (copy,nonatomic) NSString *set;
/** 价格 */
@property (copy,nonatomic) NSString *price;

@end
