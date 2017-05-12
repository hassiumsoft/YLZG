//
//  YLChatGroupDetailController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "YLGroup.h"

@interface YLChatGroupDetailController : SuperViewController

/** 回调block */
@property (copy,nonatomic) void (^GroupModelBlock)(YLGroup *groupModel);

/** 群组模型 */
@property (strong,nonatomic) YLGroup *groupModel;

/** 是否从RootVC进来的 */
@property (assign,nonatomic) BOOL isRootPush;

/** 初始化 */
- (instancetype)initWithConversation:(EMConversation *)conversation;


@end
