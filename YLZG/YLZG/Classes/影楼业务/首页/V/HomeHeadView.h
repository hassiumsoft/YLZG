//
//  HomeHeadView.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ClickType) {
    OpenOrderClick = 1,
    SearchClick = 2,
    PreOrderClick = 3
};

typedef void(^ButtonClickBlock)(ClickType clickType);

@interface HomeHeadView : UIView

@property (copy,nonatomic) void (^ButtonClickBlock)(ClickType);

+ (instancetype)sharedHomeHeadView;

@end
