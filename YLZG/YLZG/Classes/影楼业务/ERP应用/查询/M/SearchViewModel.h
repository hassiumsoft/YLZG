//
//  SearchViewModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchViewModel : NSObject

/** 客人姓名 */
@property (nonatomic, copy) NSString * guestname;
/** 电话 */
@property (nonatomic, copy) NSString * phone;
/** 订单号 */
@property (nonatomic, copy) NSString * tradeID;

/** 负责人 */
@property (copy,nonatomic) NSString *store;
/** 套系名称 */
@property (copy,nonatomic) NSString *set;
/** 价格 */
@property (copy,nonatomic) NSString *price;

@end
