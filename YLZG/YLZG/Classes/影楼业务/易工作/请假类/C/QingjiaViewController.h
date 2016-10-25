//
//  QingjiaViewController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/14.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"

/** 2种时间模式*/
typedef NS_ENUM(NSInteger,TimeType){
    startTimeType = 1, // 开始时间
    endTimeType = 2  // 结束时间
};


@interface QingjiaViewController : SuperViewController


@property (assign,nonatomic) TimeType timeType;


@end
