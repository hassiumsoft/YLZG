//
//  AllProductModel.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/19.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "AllProductModel.h"
#import <MJExtension.h>


@implementation AllProductModel

+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) return nil;
    AllProductModel *model = [super mj_objectWithKeyValues:keyValues];
    
    NSMutableArray *array = [NSMutableArray new];
    NSArray *result = [model.productList copy];
    for (NSDictionary *dic in result) {
        AllProductList *price = [AllProductList mj_objectWithKeyValues:dic];
        
        [array addObject:price];
    }
    model.productList = array;
    
    return model;
}

@end
