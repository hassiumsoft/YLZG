//
//  ProduceDetialModel.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ProduceDetialModel.h"
#import <MJExtension.h>

@implementation ProduceDetialModel

+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) return nil;
    ProduceDetialModel *model = [super mj_objectWithKeyValues:keyValues];
    
    // 成员数组
    NSMutableArray *array1 = [NSMutableArray new];
    NSArray *memberArr = [model.member copy];
    for (NSDictionary *dic in memberArr) {
        ProduceMemberModel *price = [ProduceMemberModel mj_objectWithKeyValues:dic];
        
        [array1 addObject:price];
    }
    model.member = array1;
    
    // 文件数组
    NSMutableArray *array2 = [NSMutableArray new];
    NSArray *fileArr = [model.file copy];
    for (NSDictionary *dic in fileArr) {
        ProduceFileModel *price = [ProduceFileModel mj_objectWithKeyValues:dic];
        
        [array2 addObject:price];
    }
    model.file = array2;
    // 项目任务
    NSMutableArray *array3 = [NSMutableArray new];
    NSArray *taskArr = [model.task copy];
    for (NSDictionary *dic in taskArr) {
        ProduceTaskModel *price = [ProduceTaskModel mj_objectWithKeyValues:dic];
        
        [array3 addObject:price];
    }
    model.task = array3;
    
    // 项目评论
    NSMutableArray *array4 = [NSMutableArray new];
    NSArray *discussArr = [model.discuss copy];
    for (NSDictionary *dic in discussArr) {
        ProduceDiscussModel *price = [ProduceDiscussModel mj_objectWithKeyValues:dic];
        
        [array4 addObject:price];
    }
    model.discuss = array4;
    
    return model;
}

@end
