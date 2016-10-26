//
//  UserInfoManager.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "UserInfoManager.h"
#import <MJExtension.h>
#import <FMDB.h>

static FMDatabase *_db;

@implementation UserInfoManager

+ (void)initialize
{
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    BOOL open = [_db open];
    if (open) {
        KGLog(@"打开数据库成功");
    } else {
        KGLog(@"打开数据库失败");
        return;
    }
    
    // 建表语句 缺少head、
    BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_user (id integer PRIMARY KEY AUTOINCREMENT,uid text,createtime text,username text,password text,store_simple_name text,nickname text,realname text,mobile text,birth text,type text,sid text,suid text,loginip text,logintime text,qq text,dept text,gender text,is_register_easemob bool,location text,head text,vcip text,attence_admin_group text,attence_group text);"];
    if (result) {
        KGLog(@"表格创建成功");
    }else{
        KGLog(@"表格创建失败");
    }
}

#pragma mark - 保存
+ (void)saveInfoToSandBox:(UserInfoModel *)model
{
    
    
    NSString *sql = [NSString stringWithFormat:@"insert into t_user (uid,createtime,username,password,store_simple_name,nickname,realname,mobile,birth,type,sid,suid,loginip,logintime,qq,dept,gender,is_register_easemob,location,head,vcip,attence_admin_group,attence_group) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",model.uid,model.createtime,model.username,model.password,model.store_simple_name,model.nickname,model.realname,model.mobile,model.birth,model.type,model.sid,model.suid,model.loginip,model.logintime,model.qq,model.dept,model.gender,model.is_register_easemob,model.location,model.head,model.vcip,model.attence_admin_group,model.attence_group];
    
    BOOL result = [_db executeUpdate:sql];
    if (result) {
        KGLog(@"保存成功");
    }else{
        KGLog(@"保存失败");
    }
}
#pragma mark - 修改
+ (BOOL)updataUserInfoWithKey:(NSString *)key Value:(NSString *)value
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_user SET '%@' = '%@'",key,value];
    BOOL result = [_db executeUpdate:sql];
    return result;
}

#pragma mark - 查询我的信息
+ (UserInfoModel *)getUserInfo
{
    if (![_db open]) {
        return nil;
    }
    
    NSString *sql = @"select * from t_user";
    FMResultSet *result = [_db executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([result next]) {
        UserInfoModel *user = [[UserInfoModel alloc]init];
        user.uid = [result stringForColumn:@"uid"];
        user.createtime = [result stringForColumn:@"createtime"];
        user.username = [result stringForColumn:@"username"];
        user.password = [result stringForColumn:@"password"];
        user.store_simple_name = [result stringForColumn:@"store_simple_name"];
        user.realname = [result stringForColumn:@"realname"];
        user.mobile = [result stringForColumn:@"mobile"];
        user.head = [result stringForColumn:@"head"];
        user.birth = [result stringForColumn:@"birth"];
        user.nickname = [result stringForColumn:@"nickname"];
        user.type = [result stringForColumn:@"type"];
        user.sid = [result stringForColumn:@"sid"];
        user.suid = [result stringForColumn:@"suid"];
        user.loginip = [result stringForColumn:@"loginip"];
        user.logintime = [result stringForColumn:@"logintime"];
        user.qq = [result stringForColumn:@"qq"];
        user.dept = [result stringForColumn:@"dept"];
        user.gender = [result stringForColumn:@"gender"];
        user.is_register_easemob = [result stringForColumn:@"is_register_easemob"];
        user.location = [result stringForColumn:@"location"];
        user.vcip = [result stringForColumn:@"vcip"];
        user.attence_admin_group = [result stringForColumn:@"attence_admin_group"];
        user.attence_group = [result stringForColumn:@"attence_group"];
        
        [array addObject:user];
    }
    UserInfoModel *model = [array lastObject];
    return model;
}
#pragma mark - 删除数据
+ (BOOL)deleteOneDataInfo:(NSInteger)indexID
{
    BOOL result;
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from t_offorder where id = '%ld'",(long)indexID];
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

#pragma mark - 删除t_user表格中的全部数据
+ (BOOL)deleteAllData
{
    NSString *sql = @"DELETE FROM t_user";
    BOOL result = [_db executeUpdate:sql];  // NO
    return result;
}

- (void)dealloc
{
    [_db close];
}

@end

