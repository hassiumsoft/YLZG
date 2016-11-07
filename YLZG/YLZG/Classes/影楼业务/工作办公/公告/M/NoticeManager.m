//
//  NoticeManager.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NoticeManager.h"
#import <MJExtension.h>
#import <FMDB.h>

static FMDatabase *_db;
@implementation NoticeManager

+ (void)initialize
{
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"t_notice.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    BOOL open = [_db open];
    if (open) {
        KGLog(@"打开数据库成功");
    } else {
        KGLog(@"打开数据库失败");
        return;
    }
    
    // uid、name、nickname、realname、qq、mobile、location、head、gender、dept、birth
    // 建表语句
    BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_notice (id integer PRIMARY KEY AUTOINCREMENT,noticejson long text);"];
    if (result) {
        KGLog(@"表格创建成功");
    }else{
        KGLog(@"表格创建失败");
    }
}
+ (BOOL)saveAllNoticeWithNoticeModel:(NoticeModel *)model
{
    // 保存前先删除之前的记录,保持信息最新
    if (![_db open]) {
        return NO;
    }else{
        NSDictionary *dict = [model mj_keyValues];
        NSString *memberJson = [self toJsonStr:dict];
        
        NSString *sql = [NSString stringWithFormat:@"insert into t_notice (noticejson) values ('%@')",memberJson];
        
        BOOL result = [_db executeUpdate:sql];
        if (result) {
            KGLog(@"保存成功");
        }else{
            KGLog(@"保存失败");
        }
        return result;
    }
}

+ (NSMutableArray *)getAllNoticeInfo
{
    if (![_db open]) {
        return nil;
    }
    NSString *sql = @"SELECT * FROM t_notice";
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    while (result.next) {
        
        NSString *memberJson = [result stringForColumn:@"noticejson"];
        NoticeModel *model = [NoticeModel mj_objectWithKeyValues:memberJson];
        [array addObject:model];
        KGLog(@"memberJson = %@",memberJson);
    }
    
    return array;
}

+ (BOOL)deleteAllInfo
{
    if (![_db open]) {
        return NO;
    }else{
        NSString *sql = @"DELETE FROM t_notice";
        BOOL result = [_db executeUpdate:sql];  // NO
        return result;
    }
    
}

- (void)dealloc
{
    [_db close];
}

#pragma mark -  将字典或数组转化为JSON串
+ (NSString *)toJsonStr:(id)object
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


@end
