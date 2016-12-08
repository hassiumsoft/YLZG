//
//  ZhuanfaCountModel.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/7.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ZhuanfaCountModel.h"
#import <MJExtension.h>

@implementation ZhuanfaCountModel

+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) return nil;
    ZhuanfaCountModel *model = [super mj_objectWithKeyValues:keyValues];
    
    NSMutableArray *array = [NSMutableArray new];
    NSArray *result = [model.personlist copy];
    for (NSDictionary *dic in result) {
        ZhuanfaListModel *product = [ZhuanfaListModel mj_objectWithKeyValues:dic];
        
        [array addObject:product];
    }
    model.personlist = array;
    
    return model;
}

@end
