//
//  ContactersModel.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/7.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "ContactersModel.h"
//#import <MJExtension.h>

@implementation ContactersModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setNickname:(NSString *)nickname
{
    if (nickname.length < 1) {
        _nickname = _name;
    }
}

@end
