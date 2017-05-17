//
//  UIViewController+Actions.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Actions)
/** 颜色生成图片 */
- (UIImage *)imageWithBgColor:(UIColor *)color;
/** AlertC提示 */
- (void)sendErrorWarning:(NSString *)message;
/** 获取当前东八区的年月日时间 */
- (NSString *)getCurrentAreaDateAndTime;
/** 字符串转成东八区date */
- (NSDate *)dateChanged:(NSString *)dateStr;
/** 时间戳转换为NSDate */
- (NSString *)timeIntervalToDate:(NSTimeInterval)timeInterval;
/** 时间转化为星期几格式 */
- (NSString *)weekChanged:(NSTimeInterval)timeInterval;
/** 时间戳转化为东八区时间字符串 */
- (NSString *)TimeIntToDateStr:(NSTimeInterval)timeInterval;


- (void)showHudMessage:(NSString *)message;
- (void)hideHud:(NSInteger)seconds;

/** 成功提示 */
- (void)showSuccessTips:(NSString *)tips;
/** 错误提示 */
- (void)showErrorTips:(NSString *)tips;
/** 警告 */
- (void)showWarningTips:(NSString *)tips;
/** 默认样式 */
- (void)showHint:(NSString *)hint;

#pragma mark -  将字典或数组转化为JSON串
- (NSString *)toJsonStr:(id)object;

#pragma mark -当前时间
- (NSString *)getCurrentTime;
/** 数组随机排序 */
- (NSArray *)randomizedArrayWithArray:(NSArray *)array;


/** 获取一个模型的全部属性和方法 */
- (void)getAllProtyActions:(id)ModelClass;

@end
