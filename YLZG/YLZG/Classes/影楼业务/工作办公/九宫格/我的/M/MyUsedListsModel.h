//
//  MyUsedListsModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUsedListsModel : NSObject

/** 模板分类名字 */
@property (copy,nonatomic) NSString *category;
/** 转发时间 */
@property (assign,nonatomic) NSTimeInterval create_at;
/** 模板ID */
@property (copy,nonatomic) NSString *id;
/** 模板名称 */
@property (copy,nonatomic) NSString *name;
/** 缩略图 */
@property (copy,nonatomic) NSString *thumb;


@end
