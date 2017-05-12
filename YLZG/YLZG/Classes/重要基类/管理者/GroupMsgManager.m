//
//  GroupMsgManager.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "GroupMsgManager.h"
#import <MJExtension.h>
#import <FMDB.h>
#import "YLZGDataManager.h"


static FMDatabase *_db;

@implementation GroupMsgManager

+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"t_group.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // gid、zcid、head_img、affiliations、allowinvites、dsp、gname、maxusers、membersonly、owner、pub、sid
    
    // 建表语句
    BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_group (id integer PRIMARY KEY AUTOINCREMENT,gid text,zcid text,head_img text,affiliations text,allowinvites text,dsp text,gname text,maxusers text,membersonly text,owner text,pub text,sid text);"];
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
        //    gid,zcid,affiliations,allowinvites,dsp,gname,maxusers,membersonly,owner,pub,sid
        
        NSString *sql = [NSString stringWithFormat:@"insert into t_group (gid,zcid,head_img,affiliations,allowinvites,dsp,gname,maxusers,membersonly,owner,pub,sid) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",model.gid,model.id,model.head_img,model.affiliations,model.allowinvites,model.dsp,model.gname,model.maxusers,model.membersonly,model.owner,[NSString stringWithFormat:@"%d",model.pub],model.sid];
        
        BOOL result = [_db executeUpdate:sql];
        if (result) {
            KGLog(@"保存成功");
        }else{
            KGLog(@"保存失败");
        }
        return result;
    }
}

+ (NSArray *)getAllGroupInfo
{
    if (![_db open]) {
        return nil;
    }
    NSString *sql = @"SELECT * FROM t_group";
    FMResultSet *result = [_db executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    //    zcid,gid,head_img,affiliations,allowinvites,dsp,gname,maxusers,membersonly,owner,pub,sid
    while (result.next) {
        YLGroup *model = [[YLGroup alloc]init];
        model.gid = [result stringForColumn:@"gid"];
        model.id = [result stringForColumn:@"zcid"];
        model.head_img = [result stringForColumn:@"head_img"];
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
        NSString *sql = @"DELETE FROM t_group";
        BOOL result = [_db executeUpdate:sql];  // NO
        return result;
    }
}

- (void)dealloc
{
    [_db close];
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

+ (void)getGroupInfoByGroupID:(NSString *)gID Completion:(void (^)(YLGroup *))Completion
{
    NSArray *array = [self getAllGroupInfo];
    
    for (YLGroup *model in array) {
        if ([model.gid isEqualToString:gID]) {
            Completion(model);
            return;
        }
    }
    
    // 调用环信api去获取群信息
    [[YLZGDataManager sharedManager] updataGroupInfoWithBlock:^{
        NSArray *array = [self getAllGroupInfo];
        
        for (YLGroup *model in array) {
            if ([model.gid isEqualToString:gID]) {
                Completion(model);
                
            }
        }
    }];
}

@end
