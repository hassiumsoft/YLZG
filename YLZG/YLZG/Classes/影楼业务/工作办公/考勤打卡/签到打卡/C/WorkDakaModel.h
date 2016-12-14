//
//  WorkDakaModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface WorkDakaModel : NSObject


/** 上班还是下班时间 */
@property (copy,nonatomic) NSString *time;
/** 进入打卡范围描述 */
@property (copy,nonatomic) NSString *dakaDetial;
/** 可打卡范围 */
@property (copy,nonatomic) NSString *areaMiles;
/** WiFi名称 */
@property (copy,nonatomic) NSString *wifiName;


@end
