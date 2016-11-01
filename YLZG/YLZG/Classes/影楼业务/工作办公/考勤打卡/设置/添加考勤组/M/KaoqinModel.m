//
//  KaoqinModel.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/6/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "KaoqinModel.h"
#import <MJExtension.h>

@implementation KaoqinModel

//+ (instancetype)mj_objectWithKeyValues:(id)keyValues
//{
//    if (![keyValues isKindOfClass:[NSDictionary class]]) return nil;
//    KaoqinModel *model = [super mj_objectWithKeyValues:keyValues];
//    
//    // 一周排版模型转化
//    NSMutableArray *array1 = [NSMutableArray array];
//    NSArray *result1 = [model.rules copy];
//    for (NSDictionary *dic in result1) {
//        PaibanModel *paiban = [PaibanModel mj_objectWithKeyValues:dic];
//        
//        [array1 addObject:paiban];
//    }
//    model.rules = array1;
//    
//    // 班次模型
//    NSMutableArray *array2 = [NSMutableArray array];
//    NSArray *result2 = [model.classes copy];
//    for (NSDictionary *dic in result2) {
//        BanciModel *banci = [BanciModel mj_objectWithKeyValues:dic];
//        
//        [array2 addObject:banci];
//    }
//    model.classes = array2;
//    
//    // 地址数组
//    NSMutableArray *array3 = [NSMutableArray array];
//    NSArray *result3 = [model.locations copy];
//    for (NSDictionary *dic in result3) {
//        LocationsModel *location = [LocationsModel mj_objectWithKeyValues:dic];
//        
//        [array3 addObject:location];
//    }
//    model.locations = array3;
//    
//    return model;
//}
//


+ (NSMutableArray *)mj_objectArrayWithKeyValuesArray:(id)keyValuesArray
{
    if (![keyValuesArray isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *modelArr = [super mj_objectArrayWithKeyValuesArray:keyValuesArray];
    
    for (KaoqinModel *model in modelArr) {
        if ([model.type intValue] == 1) {
            // 固定班制
            // 一周排版模型转化
            NSMutableArray *array1 = [NSMutableArray array];
            NSArray *result1 = [model.rule1 copy];
            for (NSDictionary *dic in result1) {
                GudingPaibanModel *paiban = [GudingPaibanModel mj_objectWithKeyValues:dic];
                
                [array1 addObject:paiban];
            }
            model.rule1 = array1;
        }else{
            // 排班制
            // 一周排版模型转化
            NSMutableArray *array2 = [NSMutableArray array];
            NSArray *result2 = [model.rule2 copy];
            for (NSDictionary *dic in result2) {
                GudingPaibanModel *paiban = [GudingPaibanModel mj_objectWithKeyValues:dic];
                
                [array2 addObject:paiban];
            }
            model.rule2 = array2;
        }
    }
    for (KaoqinModel *model in modelArr) {
        // 班次模型
        NSMutableArray *array2 = [NSMutableArray array];
        NSArray *result2 = [model.classes copy];
        for (NSDictionary *dic in result2) {
            BanciModel *banci = [BanciModel mj_objectWithKeyValues:dic];
            
            [array2 addObject:banci];
        }
        model.classes = array2;

    }
    
    for (KaoqinModel *model in modelArr) {
        // 地址数组
        NSMutableArray *array3 = [NSMutableArray array];
        NSArray *result3 = [model.locations copy];
        for (NSDictionary *dic in result3) {
            LocationsModel *location = [LocationsModel mj_objectWithKeyValues:dic];
            
            [array3 addObject:location];
        }
        model.locations = array3;
    }
    
    return modelArr;
}

@end
