//
//  UITableViewCell+Actions.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "UITableViewCell+Actions.h"

@implementation UITableViewCell (Actions)


- (NSString *)timeIntervalToDate:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *origanStr = [NSString stringWithFormat:@"%@",date];
    NSString *time = [origanStr substringWithRange:NSMakeRange(0, 16)];
    return time;
}

- (UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (NSString *)weekChanged:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"cccc"]; // 星期一
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
    
}

#pragma mark - 由时间戳转化为东八区时间字符串
- (NSString *)TimeIntToDateStr:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"]; // 星期一
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
    
}



@end
