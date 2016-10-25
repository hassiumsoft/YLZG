//
//  FRegionModel.h
//  佛友圈
//
//  Created by Chan_Sir on 16/3/15.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********** 区域的模型 **********/

@interface FRegionModel : NSObject

/** 区域名字 */
@property (nonatomic, copy) NSString *name;
/** 子区域 */
@property (nonatomic, strong) NSArray *subregions;

@end
