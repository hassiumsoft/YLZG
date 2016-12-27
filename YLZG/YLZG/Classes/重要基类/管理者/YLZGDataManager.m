//
//  YLZGDataManager.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "YLZGDataManager.h"
#import "HTTPManager.h"
#import "UserInfoModel.h"
#import "UserInfoManager.h"
#import "ApplyModel.h"
#import <MJExtension.h>
#import "ZCAccountTool.h"
#import "GroupListManager.h"
#import <SVProgressHUD.h>
#import "NSDate+Category.h"



typedef NSMutableArray* (^BlockType) (NSMutableArray *);
static YLZGDataManager *controller = nil;

@interface YLZGDataManager ()

//数据源
@property (nonatomic,strong) BlockType blockType;

@end
@implementation YLZGDataManager

#pragma mark -- 单例创建
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] init];
    });
    return controller;
}

#pragma mark -- 下载数据
- (void)loadUnApplyApplyFriendArr:(ApplyFriend)ApplyFriendArr{
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *URL = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/get_msg?uid=%@",account.userID];
    
    UserInfoModel *myModel = [UserInfoManager getUserInfo];
    [HTTPManager GET:URL params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"]description] intValue];
        NSMutableArray *peopleArr = [NSMutableArray array];
        if (code == 1) {
            
            NSMutableArray *result = [responseObject objectForKey:@"result"];
//#warning 这里需要对数据进行处理 接口解析的时候会有两个数据是自己申请加自己为好友 后期需要后台处理掉
            NSMutableArray *array = [ApplyModel mj_objectArrayWithKeyValuesArray:result];
            for (int i = 0; i < array.count; i++) {
                ApplyModel *model = array[i];
                if (![myModel.uid isEqualToString:model.auid]) {
                    [peopleArr addObject:model];
                }
            }
            ApplyFriendArr(peopleArr);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        KGLog(@"error = %@",error.localizedDescription);
    }];
}

- (void)saveGroupInfoWithBlock:(NoParamBlock)reloadTable
{
    
    NSArray *groups = [GroupListManager getAllGroupInfo];
    if (groups.count >= 1) {
        [GroupListManager deleteAllGroupInfo];
    }
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:@"http://zsylou.wxwkf.com/index.php/home/easemob/my_groups_list?uid=%@",account.userID];
    KGLog(@"url = %@",url);
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"]description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        NSArray *dictArray = responseObject[@"grouplist"];
        if (code == 1) {
            NSArray *groupArray = [YLGroup mj_objectArrayWithKeyValuesArray:dictArray];
            for (int i = 0; i < groupArray.count; i++) {
                YLGroup *model = groupArray[i];
                [GroupListManager saveGroupInfo:model];
            }
            reloadTable();
        }else{
            [SVProgressHUD showErrorWithStatus:message];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    }];
    
}
- (void)getOneStudioByUID:(NSString *)userID Block:(StuduoModelBlock)modelBlock
{
    NSArray *allMembers = [self getAllFriendInfo];
    if (allMembers.count >= 1) {
        for (int i = 0; i < allMembers.count; i++) {
            ContactersModel *model = allMembers[i];
            if ([userID isEqualToString:model.uid]) {
                modelBlock(model);
                return;
            }
        }
    }
    
}
- (void)getOneStudioByUserName:(NSString *)userName Block:(StuduoModelBlock)modelBlock
{
    
    NSArray *allMembers = [self getAllFriendInfo];
    if (allMembers.count >= 1) {
        for (int i = 0; i < allMembers.count; i++) {
            ContactersModel *model = allMembers[i];
            if ([userName isEqualToString:model.name]) {
                modelBlock(model);
                return;
            }
        }
    }
    
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:SearchUserInfo_URL,account.userID,userName];
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        NSString *message = [[responseObject objectForKey:@"message"] description];
        if (code == 1) {
            NSDictionary *user = [responseObject objectForKey:@"user"];
            ContactersModel *model = [ContactersModel mj_objectWithKeyValues:user];
            modelBlock(model);
        }else{
            NSLog(@"message = %@",message);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
    }];
}

- (NSMutableArray *)getAllFriendInfo
{
    
//    NSArray *huanxinArr = [HuanxinContactManager getAllHuanxinContactsInfo];
    
    // 暂时只收录同事数组
    NSArray *studioArr = [StudioContactManager getAllStudiosContactsInfo];
    
    NSMutableArray *sumArr = [NSMutableArray array];
    for (int i = 0; i < studioArr.count; i++) {
        ColleaguesModel *colleagus = studioArr[i];
        for (int j = 0; j < colleagus.member.count; j++) {
            ContactersModel *colleModel = colleagus.member[j];
            [sumArr addObject:colleModel];
        }
    }
    
//    ZCAccount *account = [ZCAccountTool account];
//    for (int i = 0; i < sumArr.count; i++) {
//        ContactersModel *model = sumArr[i];
//        if ([account.username isEqualToString:model.name]) {
//            [sumArr removeObjectAtIndex:i];
//        }
//    }
//    
    
    return sumArr;
    
}

- (void)getShareUrlCompletion:(ShareUrlBlock)shareURL
{
    ZCAccount *account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:Share_URL,account.userID];
    __block NSString *tempUrl = @"http://ylou.bjletu.com";
    
    [HTTPManager GETCache:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[[responseObject objectForKey:@"code"] description] intValue];
        if (code == 1) {
            tempUrl = [responseObject objectForKey:@"url"];
            shareURL(tempUrl);
        }else{
            shareURL(tempUrl);
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        ShareUrlBlock(tempUrl);
        NSLog(@"tempUrl = %@",tempUrl);
    }];
}


- (BOOL)isSpringFestival
{
    // 今天
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone]; // 上海时区
    NSDate *date = [NSDate date];
    NSInteger seconds = [timeZone secondsFromGMTForDate:date];
    NSDate *newDate = [date dateByAddingTimeInterval:seconds];
    NSString *str = [NSString stringWithFormat:@"%@",newDate];
    
    // 东八区的时间
    NSString *realTime = [str substringWithRange:NSMakeRange(0, 11)];
    realTime = [realTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    int todayDate = [realTime intValue];
    int springStartDate = 20170126;
    int springEndDate = 20170211;
    
    
//    if (todayDate >= springStartDate && todayDate <= springEndDate) {
//        // 春节期间
//        return YES;
//    }else{
//        // 不是春节期间
//        return NO;
//    }
    
    return YES;
    
}

@end
