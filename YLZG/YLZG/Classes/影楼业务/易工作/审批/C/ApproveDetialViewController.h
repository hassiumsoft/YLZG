//
//  ApproveDetialViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "ApproveModel.h"

@interface ApproveDetialViewController : SuperViewController


@property (copy,nonatomic) void (^ReloadBlock)();


/** 是不是我 */
@property (assign,nonatomic) BOOL isMe;
/** 急促模型 */
@property (strong,nonatomic) ApproveModel *model;
/** 已经审批 */
@property (assign,nonatomic) BOOL haveShenpi;
/** 标题 */
@property (copy,nonatomic) NSString *titleStr;

@end
