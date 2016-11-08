//
//  CardNumViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface CardNumViewController : SuperViewController

@property (copy,nonatomic) void (^SelectCardNum)(NSString *cardNum);

@end
