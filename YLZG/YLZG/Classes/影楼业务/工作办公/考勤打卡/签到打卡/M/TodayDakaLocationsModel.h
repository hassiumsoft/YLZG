//
//  TodayDakaLocationsModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>


/******* 可以打卡的位置模型 *******/

@interface TodayDakaLocationsModel : NSObject


/** 地理位置 */
@property (copy,nonatomic) NSString *address;
/** 纬度 */
@property (copy,nonatomic) NSString *latitude;
/** 经度 */
@property (copy,nonatomic) NSString *longitude;


@end
