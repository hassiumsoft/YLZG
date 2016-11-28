//
//  TaskDetialModel.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskDetialModel.h"


@implementation TaskDetialModel

+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) return nil;
    TaskDetialModel *model = [super mj_objectWithKeyValues:keyValues];
    
    // 讨论记录
    NSMutableArray *array1 = [NSMutableArray new];
    NSArray *discussArr = [model.discuss copy];
    for (NSDictionary *dic in discussArr) {
        TaskDetialDiscussModel *discuss = [TaskDetialDiscussModel mj_objectWithKeyValues:dic];
        
        [array1 addObject:discuss];
    }
    model.discuss = array1;
    // 关注者
    NSMutableArray *array2 = [NSMutableArray new];
    NSArray *careArr = [model.care copy];
    for (NSDictionary *dic in careArr) {
        TaskDetialCareModel *care = [TaskDetialCareModel mj_objectWithKeyValues:dic];
        
        [array2 addObject:care];
    }
    model.care = array2;
    // 创建记录
    NSMutableArray *array3 = [NSMutableArray new];
    NSArray *dynamicArr = [model.dynamic copy];
    for (NSDictionary *dic in dynamicArr) {
        TaskDetialDynamicModel *discuss = [TaskDetialDynamicModel mj_objectWithKeyValues:dic];
        
        [array3 addObject:discuss];
    }
    model.dynamic = array3;
    // 检查项
    NSMutableArray *array4 = [NSMutableArray new];
    NSArray *checkArr = [model.check copy];
    for (NSDictionary *dic in checkArr) {
        TaskDetialCheckModel *check = [TaskDetialCheckModel mj_objectWithKeyValues:dic];
        
        [array4 addObject:check];
    }
    model.check = array4;
    
    return model;
}

@end
