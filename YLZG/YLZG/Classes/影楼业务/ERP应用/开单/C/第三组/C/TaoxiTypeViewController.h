//
//  TaoxiTypeViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/7.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface TaoxiTypeViewController : SuperViewController

@property (copy,nonatomic) void (^SelectBlock)(NSString *TaoxiType);

@end
