//
//  TaoxiModel.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/9.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "TaoxiModel.h"
#import <MJExtension.h>


@implementation TaoxiModel


+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) return nil;
    TaoxiModel *model = [super mj_objectWithKeyValues:keyValues];
    
    NSMutableArray *array = [NSMutableArray new];
    NSArray *result = [model.child_set copy];
    for (NSDictionary *dic in result) {
        TaoxiNamePrice *price = [TaoxiNamePrice mj_objectWithKeyValues:dic];
        [array addObject:price];
    }
    model.child_set = array;
    
    return model;
}

@end
