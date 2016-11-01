//
//  SuperSettingController.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/25.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

typedef NS_ENUM(NSInteger,KaoqinTimeType) {
    AbsentTimeType = 1, // 旷工分钟数
    EarlytimeType = 2, // 最早打卡时间分钟数
    LatetimeType = 3, // 严重迟到分钟数
    PrivilegeTime = 4, // 弹性分钟数
    SplyTime = 5, // 是否绑定审批
    OffTipType = 6, // 下班提示
    OnTipType = 7, // 上班提示
    OutTipType = 8 // 外出提示
    
};

@interface SuperSettingController : SuperViewController

@property (assign,nonatomic) KaoqinTimeType timeType;

@end
