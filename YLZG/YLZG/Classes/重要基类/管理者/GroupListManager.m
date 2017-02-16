//
//  GroupListManager.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "GroupListManager.h"
#import <MJExtension.h>
#import "YLZGDataManager.h"
#import <FMDB.h>

static FMDatabase *_db;

@implementation GroupListManager

+ (void)initialize
{
    // 打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"t_groups.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    BOOL open = [_db open];
    if (open) {
        KGLog(@"打开数据库成功");
    } else {
        KGLog(@"打开数据库失败");
        return;
    }
    
    // gid、zcid、affiliations、allowinvites、dsp、gname、maxusers、membersonly、owner、pub、sid
    
    // 建表语句
    BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_groups (id integer PRIMARY KEY AUTOINCREMENT,gid text,zcid text,affiliations text,allowinvites text,dsp text,gname text,maxusers text,membersonly text,owner text,pub text,sid text);"];
    if (result) {
        KGLog(@"表格创建成功");
    }else{
        KGLog(@"表格创建失败");
    }
}


+ (BOOL)saveGroupInfo:(YLGroup *)model
{
    // 保存前先删除之前的记录,保持信息最新
    if (![_db open]) {
        return NO;
    }else{
        NSString *delete = @"select * from t_groups";
        [_db executeUpdate:delete];
        
        //    gid,zcid,affiliations,allowinvites,dsp,gname,maxusers,membersonly,owner,pub,sid
        
        NSString *sql = [NSString stringWithFormat:@"insert into t_groups (gid,zcid,affiliations,allowinvites,dsp,gname,maxusers,membersonly,owner,pub,sid) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",model.gid,model.id,model.affiliations,model.allowinvites,model.dsp,model.gname,model.maxusers,model.membersonly,model.owner,[NSString stringWithFormat:@"%d",model.pub],model.sid];
        
        BOOL result = [_db executeUpdate:sql];
        if (result) {
            KGLog(@"保存成功");
        }else{
            KGLog(@"保存失败");
        }
        return result;
    }
    
}
+ (YLGroup *)getGroupInfoByGroupName:(NSString *)groupName
{
    NSArray *array = [self getAllGroupInfo];
    YLGroup *groupModel = [YLGroup new];
    for (YLGroup *model in array) {
        if ([model.gname isEqualToString:groupName]) {
            groupModel = model;
        }
    }
    return groupModel;
    
}
+ (void)getGroupInfoByGroupID:(NSString *)gID Block:(GroupModelBlock)modelBlock
{
    NSArray *array = [self getAllGroupInfo];
    
    for (YLGroup *model in array) {
        if ([model.gid isEqualToString:gID]) {
            modelBlock(model);
            return;
        }
    }
    
    // 调用环信api去获取群信息
    [[YLZGDataManager sharedManager] saveGroupInfoWithBlock:^{
        NSArray *array = [self getAllGroupInfo];
        
        for (YLGroup *model in array) {
            if ([model.gid isEqualToString:gID]) {
                modelBlock(model);
                
            }
        }
    }];
    
    
}
+ (NSMutableArray *)getAllGroupInfo
{
    if (![_db open]) {
        return nil;
    }
    NSString *sql = @"SELECT * FROM t_groups";
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    //    zcid,gid,affiliations,allowinvites,dsp,gname,maxusers,membersonly,owner,pub,sid
    while (result.next) {
        YLGroup *model = [[YLGroup alloc]init];
        model.gid = [result stringForColumn:@"gid"];
        model.id = [result stringForColumn:@"zcid"];
        model.affiliations = [result stringForColumn:@"affiliations"];
        model.allowinvites = [result stringForColumn:@"allowinvites"];
        model.dsp = [result stringForColumn:@"dsp"];
        model.gname = [result stringForColumn:@"gname"];
        model.maxusers = [result stringForColumn:@"maxusers"];
        model.membersonly = [result stringForColumn:@"membersonly"];
        model.owner = [result stringForColumn:@"owner"];
        model.pub = [[result stringForColumn:@"pub"] boolValue];
        model.sid = [result stringForColumn:@"sid"];
        [array addObject:model];
    }
    return array;
}

+ (BOOL)deleteAllGroupInfo
{
    if (![_db open]) {
        return NO;
    }else{
        NSString *sql = @"DELETE FROM t_groups";
        BOOL result = [_db executeUpdate:sql];  // NO
        return result;
    }
    
}

- (void)dealloc
{
    [_db close];
}


@end
