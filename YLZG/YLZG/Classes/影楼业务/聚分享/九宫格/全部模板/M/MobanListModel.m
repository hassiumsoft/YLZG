//
//  MobanListModel.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/5.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MobanListModel.h"
#import <MJExtension.h>

@implementation MobanListModel

+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) return nil;
    MobanListModel *model = [super mj_objectWithKeyValues:keyValues];
    // 模板标签
    NSMutableArray *array1 = [NSMutableArray array];
    NSArray *category = model.category;
    for (NSDictionary *dict in category) {
        NineCategoryModel *categoryModel = [NineCategoryModel mj_objectWithKeyValues:dict];
        [array1 addObject:categoryModel];
    }
    model.category = array1;
    // 推荐模板
    NSMutableArray *array2 = [NSMutableArray array];
    NSArray *commend = model.commend;
    for (NSDictionary *dict in commend) {
        NineHotCommentModel *commendModel = [NineHotCommentModel mj_objectWithKeyValues:dict];
        [array2 addObject:commendModel];
    }
    model.commend = array2;
    // 推荐模板
    NSMutableArray *array3 = [NSMutableArray array];
    NSArray *hot = model.hot;
    for (NSDictionary *dict in hot) {
        NineHotCommentModel *hotModel = [NineHotCommentModel mj_objectWithKeyValues:dict];
        [array3 addObject:hotModel];
    }
    model.hot = array3;
    
    
    return model;
}

@end
