//
//  OfflineDataManager.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/20.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "OfflineDataManager.h"
#import <FMDB.h>
#import <MJExtension.h>
#import "OffLineOrder.h"

static FMDatabase *_db;

@implementation OfflineDataManager

+ (void)initialize
{
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"offlineorder.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    BOOL open = [_db open];
    if (open) {
        KGLog(@"打开数据库成功");
    }else{
        KGLog(@"打开数据库失败");
        return;
    }
    
    // 表格创建失败的原因，字段名不能为set关键字
    BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_offorder (id integer PRIMARY KEY AUTOINCREMENT,allUrl text NOT NULL,productlist text NOT NULL,guest text NOT NULL,beizhu text NOT NULL,mobile text NOT NULL,taoname text NOT NULL,price text NOT NULL,saveTime NOT NULL,spot NOT NULL);"];
    
    if (result) {
        KGLog(@"表格创建成功");
        
    }else{
        KGLog(@"表格创建失败");
        
    }
    
}
#pragma mark - 添加数据
+ (void)saveToSandBox:(NSDictionary *)parameter
{
    OffLineOrder *offOrder = [OffLineOrder mj_objectWithKeyValues:parameter];
    offOrder.saveTime = [self getCurrentAreaDateAndTime];
    
    NSString *sql = [NSString stringWithFormat:@"insert into t_offorder (allUrl,productlist,guest,mobile,taoname,price,beizhu,saveTime,spot) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",offOrder.allUrl,offOrder.productlist,offOrder.guest,offOrder.mobile,offOrder.set,offOrder.price,offOrder.msg,offOrder.saveTime,offOrder.spot];
    
    BOOL insert = [_db executeUpdate:sql];
    if (insert) {
        [YLNotificationCenter postNotificationName:YLOffLineOrderAlert object:@"1"];
    }else{
        KGLog(@"插入数据库失败");
        [YLNotificationCenter postNotificationName:YLOffLineOrderAlert object:@"0"];
    }
}

#pragma mark - 删除某条数据
+ (BOOL)deleteOrderAtIndex:(NSInteger)index
{
    BOOL result;
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from t_offorder where id = '%ld'",(long int)index];
        result = [_db executeUpdate:sql];
        if (result) {
//            [MBProgressHUD showError:@"删除成功"];
            KGLog(@"删除成功");
        }else{
//            [MBProgressHUD showError:@"删除失败"];
            KGLog(@"删除失败");
        }
        return result;
    }else{
        return result;
    }
    
}

#pragma mark - 查询数据库所有数据
+ (NSArray *)getAllOffLineOrderFromSandBox
{
    if (![_db open]) {
        // 数据库没打开，那就什么都别做
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = @"select * from t_offorder";
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next) {
        OffLineOrder *order = [[OffLineOrder alloc]init];
        order.id = [result intForColumn:@"ID"];
        order.allUrl = [result stringForColumn:@"allUrl"];
        order.productlist = [result stringForColumn:@"productlist"];
        order.guest = [result stringForColumn:@"guest"];
        order.spot = [result stringForColumn:@"spot"];
        order.mobile = [result stringForColumn:@"mobile"];
        order.set = [result stringForColumn:@"taoname"];
        order.price = [result stringForColumn:@"price"];
        order.msg = [result stringForColumn:@"beizhu"];
        order.saveTime = [result stringForColumn:@"saveTime"];
        [array addObject:order];
    }
    return array;
}

#pragma mark - 本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime Count:(int)count
{
    
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone systemTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = NSCalendarUnitSecond;
    // 通知的内容
    NSString *message = [NSString stringWithFormat:@"您有%d条离线订单未发送",count];
    notification.alertBody = message;
    notification.applicationIconBadgeNumber = count;
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *dict = [NSDictionary dictionaryWithObject:message forKey:@"key"];
    notification.userInfo = dict;
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - 获取本地时区的当前时间
+ (NSString *)getCurrentAreaDateAndTime
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


- (void)dealloc
{
    [_db close];
}

@end
