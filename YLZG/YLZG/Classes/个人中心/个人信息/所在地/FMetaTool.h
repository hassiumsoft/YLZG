//
//  FMetaTool.h
//  佛友圈
//
//  Created by Chan_Sir on 16/3/15.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 处理搜索结果内容 */

@interface FMetaTool : NSObject

/** 返回所有的344个城市 */
+ (NSArray *)cities;
/** 返回所有的分类数据 */
//+ (NSArray *)categories;
/** 返回所有的排序数据 */
+ (NSArray *)sorts;

@end
