//
//  UserInfoManager.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "UserInfoManager.h"
#import <MJExtension.h>




@implementation UserInfoManager

#pragma mark - 单例初始化
+ (instancetype)sharedManager
{
    static UserInfoManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}
#pragma mark - 保存数据
- (void)saveUserName:(NSString *)userName PassWord:(NSString *)passWord UserInfo:(UserInfoModel *)userModel Success:(void (^)())success Fail:(void (^)(NSString *))fail
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:userModel.uid forKey:@"userID"];
    [dict setValue:passWord forKey:@"password"];
    [dict setValue:userModel.username forKey:@"username"];
    ZCAccount *account = [ZCAccount accountWithDict:dict];
    [ZCAccountTool saveAccount:account];
    
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    [UD setObject:userModel.uid forKey:UUuid];
    [UD setObject:userModel.createtime forKey:UUcreatetime];
    [UD setObject:userModel.username forKey:UUusername];
    [UD setObject:userModel.password forKey:UUpassword];
    [UD setObject:userModel.store_simple_name forKey:UUstore_simple_name];
    [UD setObject:userModel.nickname forKey:UUnickname];
    [UD setObject:userModel.realname forKey:UUrealname];
    [UD setObject:userModel.mobile forKey:UUmobile];
    [UD setObject:userModel.head forKey:UUhead];
    [UD setObject:userModel.birth forKey:UUbirth];
    [UD setObject:userModel.type forKey:UUtype];
    [UD setObject:userModel.sid forKey:UUsid];
    [UD setObject:userModel.suid forKey:UUsuid];
    [UD setObject:userModel.loginip forKey:UUloginip];
    [UD setObject:userModel.qq forKey:UUqq];
    [UD setObject:userModel.vcip forKey:UUvcip];
    [UD setObject:userModel.attence_group forKey:UUattence_group];
    [UD setObject:userModel.attence_admin_group forKey:UUattence_admin_group];
    [UD setObject:userModel.dept forKey:UUdept];
    [UD setObject:userModel.gender forKey:UUgender];
    [UD setObject:userModel.is_register_easemob forKey:UUis_register_easemob];
    [UD setObject:userModel.location forKey:UUlocation];
    
    BOOL isSave = [UD synchronize];
    if (isSave) {
        success();
    }else{
        fail(@"信息保存失败");
    }
    
}
#pragma mark - 更新缓存
- (void)updateWithKey:(NSString *)key Value:(NSString *)value
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    [UD setObject:value forKey:key];
    [UD synchronize];
}

#pragma mark - 清除缓存
- (void)removeDataSave
{
    
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    [UD removeObjectForKey:UUuid];
    [UD removeObjectForKey:UUcreatetime];
    [UD removeObjectForKey:UUusername];
    [UD removeObjectForKey:UUpassword];
    [UD removeObjectForKey:UUstore_simple_name];
    [UD removeObjectForKey:UUnickname];
    [UD removeObjectForKey:UUrealname];
    [UD removeObjectForKey:UUmobile];
    [UD removeObjectForKey:UUhead];
    [UD removeObjectForKey:UUbirth];
    [UD removeObjectForKey:UUtype];
    [UD removeObjectForKey:UUsid];
    [UD removeObjectForKey:UUloginip];
    [UD removeObjectForKey:UUlogintime];
    [UD removeObjectForKey:UUqq];
    [UD removeObjectForKey:UUvcip];
    [UD removeObjectForKey:UUattence_admin_group];
    [UD removeObjectForKey:UUattence_group];
    [UD removeObjectForKey:UUdept];
    [UD removeObjectForKey:UUgender];
    [UD removeObjectForKey:UUis_register_easemob];
    [UD removeObjectForKey:UUlocation];
}

#pragma mark - 获取用户模型
- (UserInfoModel *)getUserInfo
{
    UserInfoModel *userModel = [UserInfoModel new];
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    NSString *userID = [UD objectForKey:UUuid];
    NSString *createtime = [UD objectForKey:UUcreatetime];
    NSString *username = [UD objectForKey:UUusername];
    NSString *password = [UD objectForKey:UUpassword];
    NSString *store_simple_name = [UD objectForKey:UUstore_simple_name];
    NSString *nickname = [UD objectForKey:UUnickname];
    NSString *realname = [UD objectForKey:UUrealname];
    NSString *mobile = [UD objectForKey:UUmobile];
    NSString *head = [UD objectForKey:UUhead];
    NSString *birth = [UD objectForKey:UUbirth];
    NSString *type = [UD objectForKey:UUtype];
    NSString *sid = [UD objectForKey:UUsid];
    NSString *suid = [UD objectForKey:UUsuid];
    NSString *loginip = [UD objectForKey:UUloginip];
    NSString *logintime = [UD objectForKey:UUlogintime];
    NSString *qq = [UD objectForKey:UUqq];
    NSString *vcip = [UD objectForKey:UUvcip];
    NSString *attence_group = [UD objectForKey:UUattence_group];
    NSString *attence_admin_group = [UD objectForKey:UUattence_admin_group];
    NSString *dept = [UD objectForKey:UUdept];
    NSString *gender = [UD objectForKey:UUgender];
    NSString *is_register_easemob = [UD objectForKey:UUis_register_easemob];
    NSString *location = [UD objectForKey:UUlocation];
    
    userModel.uid = userID;
    userModel.createtime = createtime;
    userModel.username = username;
    userModel.password = password;
    userModel.store_simple_name = store_simple_name;
    userModel.nickname = nickname;
    userModel.realname = realname;
    userModel.mobile = mobile;
    userModel.head = head;
    userModel.birth = birth;
    userModel.birth = birth;
    userModel.sid = sid;
    userModel.type = type;
    userModel.suid = suid;
    userModel.loginip = loginip;
    userModel.logintime = logintime;
    userModel.qq = qq;
    userModel.vcip = vcip;
    userModel.attence_admin_group = attence_admin_group;
    userModel.attence_group = attence_group;
    userModel.dept = dept;
    userModel.gender = gender;
    userModel.is_register_easemob = is_register_easemob;
    userModel.location = location;
    
    
    return userModel;
}

@end

