//
//  SearchModel.m
//  YLZG
//
//  Created by apple on 2016/10/31.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

/**
 *  新建 一个搜索数据模型
 *
 *  @param keyWord 搜索关键字
 *  @param currentTime 时间
 *
 *  @return 搜索模型
 */
+ (SearchModel *)creatSearchModel:(NSString *)keyWord currentTime:(NSString *)currentTime {
    SearchModel *model = [[SearchModel alloc] init];
    model.keyWord = keyWord;
    model.currentTime = currentTime;
    return model;
}

@end
