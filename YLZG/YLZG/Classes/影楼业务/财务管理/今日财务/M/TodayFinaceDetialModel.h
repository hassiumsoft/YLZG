//
//  TodayFinaceDetialModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayFinaceDetialModel : NSObject

/** 收款记录数组 */
@property (copy,nonatomic) NSArray *list;
/** 收款类型 */
@property (copy,nonatomic) NSString *type;

@end
