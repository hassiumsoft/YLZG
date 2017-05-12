//
//  SearchMessageViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/11.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface SearchMessageViewController : SuperViewController


/**
 初始化
 
 会话模型
 @return 自己
 */
- (instancetype)initWithConversation:(EMConversation *)conversation;


@end
