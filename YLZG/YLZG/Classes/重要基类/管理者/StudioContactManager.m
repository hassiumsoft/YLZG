//
//  StudioContactManager.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "StudioContactManager.h"
#import <MJExtension.h>
#import "ContactersModel.h"
#import <FMDB.h>

static FMDatabase *_db;

@implementation StudioContactManager

+ (void)initialize
{
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"studio_contacts.sqlite"];
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
    BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS studio_contacts (id integer PRIMARY KEY AUTOINCREMENT,dept text,member long text);"];
    if (result) {
        KGLog(@"表格创建成功");
    }else{
        KGLog(@"表格创建失败");
    }
}

#pragma mark - 保存单个同事信息
+ (BOOL)saveAllStudiosContactsInfo:(ColleaguesModel *)studiosModel
{
    
    // 保存前先删除之前的记录,保持信息最新
    if (![_db open]) {
        return nil;
    }
    NSString *delete = @"select * from studio_contacts";
    [_db executeUpdate:delete];
    
    // uid,name,nickname,realname,qq,mobile,location,head,gender,dept,birth
    
    NSDictionary *dict = [studiosModel mj_keyValues];
    NSArray *memArr = [dict objectForKey:@"member"];
    NSString *memberJson = [self toJsonStr:memArr];
    
    NSString *sql = [NSString stringWithFormat:@"insert into studio_contacts (dept,member) values ('%@','%@')",studiosModel.dept,memberJson];
    
    BOOL result = [_db executeUpdate:sql];
    if (result) {
        KGLog(@"保存成功");
    }else{
        KGLog(@"保存失败");
    }
    return result;
}
#pragma mark - 获取全部影楼同事信息
+ (NSMutableArray *)getAllStudiosContactsInfo
{
    if (![_db open]) {
        return nil;
    }
    NSString *sql = @"SELECT * FROM studio_contacts";
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    // uid,name,nickname,realname,qq,mobile,location,head,gender,dept,birth
    while (result.next) {
        
        NSString *memberJson = [result stringForColumn:@"member"];
        NSArray *memberArray = [ContactersModel mj_objectArrayWithKeyValuesArray:memberJson];
        
        ColleaguesModel *model = [ColleaguesModel new];
        model.dept = [result stringForColumn:@"dept"];
        model.member = memberArray;
        [array addObject:model];
    }
    return array;
    
}
+ (BOOL)deleteAllInfo
{
    if (![_db open]) {
        return NO;
    }else{
        NSString *sql = @"DELETE FROM studio_contacts";
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

