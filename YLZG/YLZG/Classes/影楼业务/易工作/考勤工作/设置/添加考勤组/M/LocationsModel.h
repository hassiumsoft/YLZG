//
//  LocationsModel.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/6/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********** 地址模型 **********/

@interface LocationsModel : NSObject

/** 地址信息 */
@property (copy,nonatomic) NSString *address;
/** 经度 */
@property (copy,nonatomic) NSString *longitude;
/** 维度 */
@property (copy,nonatomic) NSString *latitude;

@end
