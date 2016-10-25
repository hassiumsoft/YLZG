//
//  FCityModel.m
//  佛友圈
//
//  Created by Chan_Sir on 16/3/15.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "FCityModel.h"
#import <MJExtension.h>
#import "FRegionModel.h"

@implementation FCityModel

- (NSDictionary *)objectInRegionsAtIndex:(NSUInteger)index
{
    return @{@"regions":[FRegionModel class]};
}

@end
