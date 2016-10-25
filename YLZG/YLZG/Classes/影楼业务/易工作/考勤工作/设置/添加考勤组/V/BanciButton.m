//
//  BanciButton.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "BanciButton.h"

@implementation BanciButton


- (DetialBanciModel *)detialBanciModel
{
    if (!_detialBanciModel) {
        _detialBanciModel = [[DetialBanciModel alloc]init];
    }
    return _detialBanciModel;
}


@end
