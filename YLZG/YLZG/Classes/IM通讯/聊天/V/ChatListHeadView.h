//
//  ChatListHeadView.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ClickType) {
    WorkZhushouType = 1,  // 工作助手
    WorkMishuType = 2  // 小秘书
};

@interface ChatListHeadView : UIView

@property (copy,nonatomic) void (^ClickBlock)(ClickType clickType);

@end
