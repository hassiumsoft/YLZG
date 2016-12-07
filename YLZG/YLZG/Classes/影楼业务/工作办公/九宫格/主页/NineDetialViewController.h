//
//  NineDetialViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/5.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface NineDetialViewController : SuperViewController

/** 是否有管理权限 */
@property (assign,nonatomic) BOOL isManager;

/** 在团队已用里面用 */
@property (copy,nonatomic) NSString *date;
/** 模板ID */
@property (copy,nonatomic) NSString *mobanID;

@end
