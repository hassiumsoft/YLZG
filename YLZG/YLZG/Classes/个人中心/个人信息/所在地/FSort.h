//
//  FSort.h
//  佛友圈
//
//  Created by Chan_Sir on 16/3/15.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/****** 排序模型 ******/

@interface FSort : NSObject

/** 排序名称 */
@property (copy,nonatomic) NSString *label;
/** 排序的值 */
@property (assign,nonatomic) int value;

@end
