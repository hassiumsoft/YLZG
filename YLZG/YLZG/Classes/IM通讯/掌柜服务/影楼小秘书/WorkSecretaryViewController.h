//
//  WorkSecretaryViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface WorkSecretaryViewController : SuperViewController

/** 初始化 */
- (instancetype)initWithVersionArray:(NSArray *)versionArray;
/** 发送消息之后的回调，更新最后一条消息 */
@property (copy,nonatomic) void (^RefrashBlock)();

@end
