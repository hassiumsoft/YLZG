//
//  ApplyModel.m
//  YLZG
//
//  Created by 周聪 on 16/9/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ApplyModel.h"
#import <MJExtension.h>

@implementation ApplyModel


//+ (NSMutableArray *)mj_objectArrayWithKeyValuesArray:(id)keyValuesArray
//{
//    if (![keyValuesArray isKindOfClass:[NSArray class]]) return nil;
//    NSMutableArray *modelArray = [super mj_objectArrayWithKeyValuesArray:keyValuesArray];
//    //    NSMutableArray *modelArray = [NSMutableArray array];
//    for (ApplyModel *model in modelArray) {
//        NSMutableArray *array1 = [NSMutableArray array];
//        NSArray *result1 = [model.result copy];
//        for (NSDictionary *dic in result1) {
//             AppleyDetailModel *contacts = [AppleyDetailModel mj_objectWithKeyValues:dic];
//            
//            [array1 addObject:contacts];
//        }
//        model.result = array1;
//    }
//    
//    return modelArray;
//    
//}
@end
