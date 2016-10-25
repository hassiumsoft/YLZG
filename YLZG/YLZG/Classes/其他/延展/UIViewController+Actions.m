//
//  UIViewController+Actions.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "UIViewController+Actions.h"
#import <SVProgressHUD.h>

@implementation UIViewController (Actions)
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

- (void)sendErrorWarning:(NSString *)message
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}
- (NSDate *)dateChanged:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone]; // 上海时区
    NSInteger seconds = [timeZone secondsFromGMTForDate:date];
    NSDate *newDate = [date dateByAddingTimeInterval:seconds];
    
    return newDate;
}
#pragma mark -  将字典或数组转化为JSON串
- (NSString *)toJsonStr:(id)object
{
    NSError *error = nil;
    // ⚠️ 参数可能是模型数组，需要转字典数组
    if (object) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData.length < 5 || error) {
            KGLog(@"解析错误");
        }
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
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


- (NSString *)getCurrentAreaDateAndTime
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone]; // 上海时区
    NSDate *date = [NSDate date];
    NSInteger seconds = [timeZone secondsFromGMTForDate:date];
    NSDate *newDate = [date dateByAddingTimeInterval:seconds];
    NSString *str = [NSString stringWithFormat:@"%@",newDate];
    
    // 东八区的时间
    NSString *realTime = [str substringWithRange:NSMakeRange(0, 16)];
    return realTime;
}


#pragma mark -当前时间
- (NSString *)getCurrentTime {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString * returnStr = [formatter stringFromDate:[NSDate date]];
    return returnStr;
}
- (void)showErrorTips:(NSString *)tips
{
    [SVProgressHUD showErrorWithStatus:tips];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
    [self hideHud:2];
}
- (void)hideHud:(NSInteger)seconds
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
- (void)showSuccessTips:(NSString *)tips
{
    [SVProgressHUD showSuccessWithStatus:tips];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [self hideHud:2];
}
- (void)showWarningTips:(NSString *)tips
{
    [SVProgressHUD showInfoWithStatus:tips];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [self hideHud:2];
}
- (void)showHint:(NSString *)hint
{
    [SVProgressHUD showInfoWithStatus:hint];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [self hideHud:2];
}
- (void)showHudMessage:(NSString *)message
{
    [SVProgressHUD showWithStatus:message];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
}

- (void)getAllProtyActions:(id)ModelClass
{
    unsigned int propertyCount;
    objc_property_t *propertyList = class_copyPropertyList([ModelClass class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        KGLog(@"私有属性 = %@",[NSString stringWithUTF8String:propertyName]);
    }
    
    unsigned int methodCount;
    Method *methodList = class_copyMethodList([ModelClass class], &methodCount);
    for (unsigned i = 0; i < methodCount; i++) {
        Method method = methodList[i];
        KGLog(@"私有方法 = %@",NSStringFromSelector(method_getName(method)));
    }
    
    unsigned int protocolCount;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([ModelClass class], &protocolCount);
    for (unsigned int i = 0; i < protocolCount; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        KGLog(@"协议方法 => %@",[NSString stringWithUTF8String:protocolName]);
    }
    
}


@end
