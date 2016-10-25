//
//  ZCAccount.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


/*********** 主要保存一些固定的信息，如登录名、ID ***********/

@interface ZCAccount : NSObject<NSCoding>

/** ERP登录账户 */
@property (strong,nonatomic) NSString *username;
/** ERP登录密码 */
@property (strong,nonatomic) NSString *password;
/** 在雷哥服务器端的用户ID */
@property (nonatomic, strong) NSString *userID;


+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
