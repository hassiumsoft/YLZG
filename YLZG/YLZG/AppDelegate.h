//
//  AppDelegate.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTabbarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    EMConnectionState _connectionState;
}
@property (strong, nonatomic) UIWindow *window;

@property (assign,nonatomic) BOOL isShowNewPage;

@property (strong,nonatomic) HomeTabbarController *homeTabbar;

@end

