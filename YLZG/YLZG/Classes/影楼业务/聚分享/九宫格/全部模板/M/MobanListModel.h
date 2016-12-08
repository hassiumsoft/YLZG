//
//  MobanListModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/5.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NineHotCommentModel.h"
#import "NineCategoryModel.h"


@interface MobanListModel : NSObject

/** 分类标签 */
@property (strong,nonatomic) NSMutableArray *category;
/** 推荐模板 */
@property (copy,nonatomic) NSArray *commend;
/** 热门模板 */
@property (copy,nonatomic) NSArray *hot;

@end
