//
//  FMetaTool.m
//  佛友圈
//
//  Created by Chan_Sir on 16/3/15.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "FMetaTool.h"
#import "FCityModel.h"
#import <MJExtension.h>
#import "FCityGroup.h"
#import "FSort.h"
//#import "<#header#>"

@implementation FMetaTool
static NSArray *_cities;
+ (NSArray *)cities
{
    if (_cities == nil) {
        _cities = [FCityModel mj_objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

static NSArray *_sorts;
+ (NSArray *)sorts
{
    if (_sorts == nil) {
        _sorts = [FSort mj_objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}

@end
