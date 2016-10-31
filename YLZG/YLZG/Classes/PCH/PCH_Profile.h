//
//  PCH_Profile.h
//  PhotoManager
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#ifndef PCH_Profile_h
#define PCH_Profile_h


// 环信相关

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define KNOTIFICATION_CALL @"callOutWithChatter"
#define KNOTIFICATION_CALL_CLOSE @"callControllerClose"
#define kGroupMessageAtList      @"em_at_list"
#define kGroupMessageAtAll       @"all"
#define kSDKConfigEnableConsoleLogger @"SDKConfigEnableConsoleLogger"
#define kEaseUISDKConfigIsUseLite @"isUselibEaseMobClientSDKLite"



// 本工程相关

// 获取设备宽
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
// 高
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
// RGB
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]


// 蒙蒙的图层
#define CoverColor RGBACOLOR(79, 79, 100, 0.8)
// 随机颜色
#define HWRandomColor RGBACOLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),1)
// 子线程
#define ZCGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
// 主线程
#define ZCMainQueue dispatch_get_main_queue()
//  比例
#define CKproportion [[UIScreen mainScreen] bounds].size.width/375.0f
// iOS系统版本
#define iOS_Version [[[UIDevice currentDevice] systemVersion] doubleValue]

// 主要颜色
#define MainColor RGBACOLOR(31, 139, 229, 1)
// 微信里删除的红色
#define WechatRedColor RGBACOLOR(227, 69, 69, 1)
// 当前控制器默认背景颜色
#define NorMalBackGroudColor RGBACOLOR(235, 240, 242, 1)
// 聊天界面toolbar的颜色
#define ToolBarColor RGBACOLOR(230, 235, 237, 1)
// 导航控制器颜色
#define NavColor RGBACOLOR(58, 58, 58, 1)

// 获取设备的bounds
#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds



#ifdef DEBUG // 处于开发阶段
#define KGLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define KGLog(...)
#endif

#define LogFuncName KGLog(@"___%s___",__func__);

#endif
