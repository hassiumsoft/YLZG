//
//  ChatListHeadView.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VersionInfoModel.h"
#import "LoginInfoModel.h"

typedef NS_ENUM(NSInteger,ClickType) {
    WorkZhushouType = 1,  // 工作助手
    WorkMishuType = 2  // 小秘书
};

@interface ChatListHeadView : UIView

/** 版本信息模型 */
@property (strong,nonatomic) VersionInfoModel *versionModel;
/** 登录信息模型 */
@property (strong,nonatomic) LoginInfoModel *loginModel;

/** 点击回调 */
@property (copy,nonatomic) void (^ClickBlock)(ClickType clickType);

@end
