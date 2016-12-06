//
//  NineHotCommentModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/******** 模板分类列表 ********/

@interface NineHotCommentModel : NSObject

/** id */
@property (copy,nonatomic) NSString *id;
/** 名称 */
@property (copy,nonatomic) NSString *name;
/** sid */
@property (copy,nonatomic) NSString *sid;
/** 图片 */
@property (copy,nonatomic) NSString *thumb;

@end
