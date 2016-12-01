//
//  ChangeTaoxiController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"
#import "TaoxiNamePrice.h"


@interface ChangeTaoxiController : SuperViewController

@property (copy,nonatomic) void (^SelectBlock)(TaoxiNamePrice *taoxiNamePrice);

@end
