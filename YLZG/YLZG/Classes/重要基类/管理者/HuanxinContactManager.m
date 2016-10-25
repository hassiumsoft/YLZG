//
//  HuanxinContactManager.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HuanxinContactManager.h"
#import <MJExtension.h>
#import <FMDB.h>

static FMDatabase *_db;

@implementation HuanxinContactManager

+ (void)initialize
{
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"huanxin_contacts.sqlite"];
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
    BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS huanxin_contacts (id integer PRIMARY KEY AUTOINCREMENT,uid text,name text,sid text,nickname text,realname text,qq text,mobile text,location text,head text,gender text,dept text,birth text);"];
    if (result) {
        KGLog(@"表格创建成功");
    }else{
        KGLog(@"表格创建失败");
    }
}

#pragma mark - 保存单个同事信息
+ (BOOL)saveAllHuanxinContactsInfo:(ContactersModel *)contactModel
{
    
    // 保存前先删除之前的记录,保持信息最新
    if (![_db open]) {
        return nil;
    }
    NSString *delete = @"select * from huanxin_contacts";
    [_db executeUpdate:delete];
    
    // uid,name,nickname,realname,qq,mobile,location,head,gender,dept,birth
    
    NSString *sql = [NSString stringWithFormat:@"insert into huanxin_contacts (uid,name,sid,nickname,realname,qq,mobile,location,head,gender,dept,birth) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",contactModel.uid,contactModel.name,contactModel.sid,contactModel.nickname,contactModel.realname,contactModel.qq,contactModel.mobile,contactModel.location,contactModel.head,contactModel.gender,contactModel.dept,contactModel.birth];
    
    BOOL result = [_db executeUpdate:sql];
    if (result) {
        KGLog(@"保存成功");
    }else{
        KGLog(@"保存失败");
    }
    return result;
}
#pragma mark - 获取全部环信好友信息
+ (NSMutableArray *)getAllHuanxinContactsInfo
{
    if (![_db open]) {
        return nil;
    }
    NSString *sql = @"SELECT * FROM huanxin_contacts";
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    // uid,name,nickname,realname,qq,mobile,location,head,gender,dept,birth
    while (result.next) {
        ContactersModel *model = [[ContactersModel alloc]init];
        model.uid = [result stringForColumn:@"uid"];
        model.name = [result stringForColumn:@"name"];
        model.sid = [result stringForColumn:@"sid"];
        model.nickname = [result stringForColumn:@"nickname"];
        model.realname = [result stringForColumn:@"realname"];
        model.mobile = [result stringForColumn:@"mobile"];
        model.head = [result stringForColumn:@"head"];
        model.birth = [result stringForColumn:@"birth"];
        model.qq = [result stringForColumn:@"qq"];
        model.dept = [result stringForColumn:@"dept"];
        model.gender = [result stringForColumn:@"gender"];
        model.location = [result stringForColumn:@"location"];
        [array addObject:model];
    }
    return array;
    
}
+ (ContactersModel *)getOneFriendByUserName:(NSString *)userName
{
    NSArray *array = [self getAllHuanxinContactsInfo];
    ContactersModel *contactModel = [ContactersModel new];
    for (ContactersModel *model in array) {
        if ([model.name isEqualToString:userName]) {
            contactModel = model;
        }
    }
    return contactModel;
    
}
+ (BOOL)deleteAllInfo
{
    if (![_db open]) {
        return NO;
    }else{
        NSString *sql = @"DELETE FROM huanxin_contacts";
        BOOL result = [_db executeUpdate:sql];  // NO
        return result;
    }
    
}

- (void)dealloc
{
    [_db close];
}

@end
