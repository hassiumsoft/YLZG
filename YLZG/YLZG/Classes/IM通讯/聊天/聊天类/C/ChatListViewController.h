//
//  ChatListViewController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface ChatListViewController : SuperViewController

/** 网络状态监听 */
- (void)networkChanged:(EMConnectionState)connectionState;
/** 获取聊天列表 */
- (void)getDataFromRAM;


@end
