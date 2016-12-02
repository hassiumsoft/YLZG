//
//  OffLineOrder.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/23.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "OffLineOrder.h"

@implementation OffLineOrder

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setMsg:(NSString *)msg
{
    if (msg.length < 1) {
        msg = @"无备注";
    }
}

@end
