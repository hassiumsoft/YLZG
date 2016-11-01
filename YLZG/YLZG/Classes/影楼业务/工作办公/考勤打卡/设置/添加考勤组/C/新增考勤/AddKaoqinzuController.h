//
//  AddKaoqinzuController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/15.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"

typedef NS_ENUM(NSInteger,PaibanType) {
    GudingBanciType = 1, // 固定班次
    PaibanBanciType = 2  // 排班班次
};

@interface AddKaoqinzuController : SuperViewController

@property (assign,nonatomic) PaibanType banciType;

@end
