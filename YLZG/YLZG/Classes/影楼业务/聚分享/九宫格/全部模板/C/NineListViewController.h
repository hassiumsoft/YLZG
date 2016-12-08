//
//  NineListViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/4.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "NineCategoryModel.h"

@interface NineListViewController : SuperViewController

/** 是否为热门/推荐。1：有筛选，0：不筛选 */
@property (assign,nonatomic) BOOL isSuaixuan;

/** 默认的分类 */
@property (strong,nonatomic) NineCategoryModel *cateModel;
/** 分类列表数组 */
@property (copy,nonatomic) NSArray *cateModelArray;

@end
