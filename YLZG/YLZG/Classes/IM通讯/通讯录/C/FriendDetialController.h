//
//  FriendDetialController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/19.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "ContactersModel.h"

@interface FriendDetialController : SuperViewController

/** 同事模型 */
@property (strong,nonatomic) ContactersModel *contactModel;
/** 是否为root界面进来的 */
@property (assign,nonatomic) BOOL isRootPush;

@end
