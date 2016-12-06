//
//  MyUsedModel.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MyUsedModel.h"
#import <MJExtension.h>

@implementation MyUsedModel

+ (NSMutableArray *)mj_objectArrayWithKeyValuesArray:(id)keyValuesArray
{
    if (![keyValuesArray isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *modelArray = [super mj_objectArrayWithKeyValuesArray:keyValuesArray];
    for (MyUsedModel *model in modelArray) {
        NSMutableArray *array1 = [NSMutableArray array];
        
        NSArray *result1 = [model.lists copy];
        for (NSDictionary *dic in result1) {
            MyUsedListsModel *contacts = [MyUsedListsModel mj_objectWithKeyValues:dic];
            
            [array1 addObject:contacts];
        }
        model.lists = array1;
    }
    
    return modelArray;
}



@end
