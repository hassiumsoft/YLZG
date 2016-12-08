//
//  MobanCateListModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/5.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********** 模板分类列表 *********/

@interface MobanCateListModel : NSObject

/** 推荐指数 */
@property (assign,nonatomic) int commend;
/** 创建时间 */
@property (assign,nonatomic) NSTimeInterval create_at;
/** 模板ID */
@property (copy,nonatomic) NSString *id;
/** 模板名称 */
@property (copy,nonatomic) NSString *name;
/** 转发次数 */
@property (assign,nonatomic) int retranstimes;
/** 所属店铺SID， 0表示为公有 */
@property (copy,nonatomic) NSString *sid;
/** 塑料图 */
@property (copy,nonatomic) NSString *thumb;

@end
