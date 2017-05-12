//
//  AddMoreView.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ClickIndex) {
    CreateGroupIndex = 0, // 发起群聊
    AddFriendIndex = 1  // 添加朋友
};

@interface AddMoreView : UIView

@property (copy,nonatomic) void (^DidSelectBlock)(ClickIndex index);

@end
