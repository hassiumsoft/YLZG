//
//  UITableViewCell+Actions.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Actions)

/** 颜色生成图片 */
- (UIImage *)imageWithBgColor:(UIColor *)color;

/** 时间戳转换为NSDate */
- (NSString *)timeIntervalToDate:(NSTimeInterval)timeInterval;
/** 时间转化为星期几格式 */
- (NSString *)weekChanged:(NSTimeInterval)timeInterval;
/** 时间戳转化为东八区时间字符串 */
- (NSString *)TimeIntToDateStr:(NSTimeInterval)timeInterval;

@end
