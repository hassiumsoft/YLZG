//
//  ChatDetialViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/5.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface ChatDetialViewController : SuperViewController

/**
 初始化
 
 会话模型
 @return 自己
 */
- (instancetype)initWithConversation:(EMConversation *)conversation;

/** 对方的信息 */
@property (strong,nonatomic) ContactersModel *contactModel;

@end
