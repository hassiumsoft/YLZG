//
//  SpotViewController.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"


@interface SpotViewController : SuperViewController

@property (copy,nonatomic) void (^SelectBlock)(NSString *spotJson,NSString *place);

@end
