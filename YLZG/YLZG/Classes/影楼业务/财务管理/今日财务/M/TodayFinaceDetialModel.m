//
//  TodayFinaceDetialModel.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TodayFinaceDetialModel.h"
#import <MJExtension.h>
#import "CaiwuDetialModel.h"


@implementation TodayFinaceDetialModel


+ (NSMutableArray *)mj_objectArrayWithKeyValuesArray:(id)keyValuesArray
{
    if (![keyValuesArray isKindOfClass:[NSArray class]]) return nil;
    
    NSMutableArray *modelArray = [super mj_objectArrayWithKeyValuesArray:keyValuesArray];
    for (TodayFinaceDetialModel *model in modelArray) {
        NSMutableArray *array1 = [NSMutableArray array];
        
        NSArray *result1 = [model.list copy];
        for (NSDictionary *dic in result1) {
            CaiwuDetialModel *contacts = [CaiwuDetialModel mj_objectWithKeyValues:dic];
            
            [array1 addObject:contacts];
        }
        model.list = array1;
    }
    
    return modelArray;
    
    
}


@end
