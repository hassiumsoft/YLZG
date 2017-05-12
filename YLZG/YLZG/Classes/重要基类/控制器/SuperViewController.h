//
//  SuperViewController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SuperViewController : UIViewController

/** 网络数据为空或其他异常时，把message显示在视图上 */
- (void)showEmptyViewWithMessage:(NSString *)message;
/** 隐藏message */
- (void)hideMessageAction;

@end
