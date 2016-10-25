//
//  CityViewController.h
//  佛友圈
//
//  Created by Chan_Sir on 16/3/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//


#import "SuperViewController.h"

@interface CityViewController : SuperViewController

@property (copy,nonatomic) NSString *city;

@property (copy,nonatomic) void (^CityBlock)(NSString *city);

@end
