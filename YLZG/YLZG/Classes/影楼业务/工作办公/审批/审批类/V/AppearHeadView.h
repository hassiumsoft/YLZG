//
//  AppearHeadView.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/31.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AppearType) {
    WaitAppearType = 10,// 待我审批
    AppearedType = 11,// 我已审批
    MyApplyType = 12 //我发起的
};

@interface AppearHeadView : UIView

@property (copy,nonatomic) void (^ClickBlock)(AppearType);

@end
