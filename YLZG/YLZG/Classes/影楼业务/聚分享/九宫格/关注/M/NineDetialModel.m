//
//  NineDetialModel.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/5.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NineDetialModel.h"
#import <MJExtension.h>


@implementation NineDetialModel


+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) return nil;
    NineDetialModel *model = [super mj_objectWithKeyValues:keyValues];
    
    NSMutableArray *array = [NSMutableArray new];
    NSArray *result = [model.images copy];
    for (NSDictionary *dic in result) {
        NineDetialImageModel *product = [NineDetialImageModel mj_objectWithKeyValues:dic];
        
        [array addObject:product];
    }
    
//    model.images = array;
    
    model.images = [array sortedArrayUsingComparator:^NSComparisonResult(NineDetialImageModel *imageModel1, NineDetialImageModel *imageModel2) {
        return [imageModel1.id compare:imageModel2.id];
    }];
    
    return model;
}




@end
