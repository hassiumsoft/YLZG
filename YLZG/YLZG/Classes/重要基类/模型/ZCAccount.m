//
//  ZCAccount.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZCAccount.h"

@implementation ZCAccount

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    ZCAccount *account = [[self alloc]init];
    account.username = dict[@"username"];
    account.password = dict[@"password"];
    account.userID = dict[@"userID"];
    
    
    return account;
}
/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        
    }
    return self;
}


@end
