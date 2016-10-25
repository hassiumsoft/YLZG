//
//  WaichuViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

/** 2种时间模式*/
typedef NS_ENUM(NSInteger,OutTimeType){
    outStartTimeType = 1, // 开始时间
    outEndTimeType = 2  // 结束时间
};


@interface WaichuViewController : SuperViewController

@property (assign,nonatomic) OutTimeType timeType;

@end
