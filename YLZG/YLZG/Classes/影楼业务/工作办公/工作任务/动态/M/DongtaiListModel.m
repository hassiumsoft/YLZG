//
//  DongtaiListModel.m
//  YLZG
//
//  Created by Chan_Sir on 2017/1/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "DongtaiListModel.h"


@implementation DongtaiListModel

+ (NSMutableArray *)mj_objectArrayWithKeyValuesArray:(id)keyValuesArray
{
    if (![keyValuesArray isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *modelArray = [super mj_objectArrayWithKeyValuesArray:keyValuesArray];
    for (DongtaiListModel *model in modelArray) {
        NSMutableArray *array1 = [NSMutableArray array];
        
        NSArray *result1 = [model.lists copy];
        for (NSDictionary *dic in result1) {
            TodayDongtaiModel *contacts = [TodayDongtaiModel mj_objectWithKeyValues:dic];
            
            [array1 addObject:contacts];
        }
        model.lists = array1;
    }
    
    return modelArray;
}

@end
