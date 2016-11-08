//
//  RudiRuceVController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface RudiRuceVController : SuperViewController

/** 入底还是入册 */
@property (assign,nonatomic) BOOL rudiruceType;

/** 回调 */
@property (copy,nonatomic) void (^RudiRuceBlock)(NSString *numberStr);

@end
