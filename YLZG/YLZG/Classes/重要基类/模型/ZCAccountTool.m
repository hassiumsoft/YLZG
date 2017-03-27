//
//  ZCAccountTool.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ZCAccountTool.h"

#define accountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation ZCAccountTool

+ (void)saveAccount:(ZCAccount *)account
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:accountPath];
}
#pragma mark - 返回账号信息
+ (ZCAccount *)account
{
    //  加载模型
    ZCAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
    return account;
}

@end
