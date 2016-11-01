//
//  ShenpiSuggestController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/25.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"
#import "ApproveModel.h"

@interface ShenpiSuggestController : SuperViewController

/** 是否同意 */
@property (assign,nonatomic) BOOL isAgree;
/** 传审批类型 */
@property (strong,nonatomic) ApproveModel *model;

@end
