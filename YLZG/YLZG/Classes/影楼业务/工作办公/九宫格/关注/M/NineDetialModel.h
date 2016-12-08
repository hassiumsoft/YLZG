//
//  NineDetialModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/5.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NineDetialImageModel.h"


@interface NineDetialModel : NSObject

/** 分类ID */
@property (copy,nonatomic) NSString *cid;
/** 描述 */
@property (copy,nonatomic) NSString *content;
/** ID 模板*/
@property (copy,nonatomic) NSString *id;
/** 名称 */
@property (copy,nonatomic) NSString *name;


/** 9张图片 */
@property (copy,nonatomic) NSArray *images;

/** 统计详情 */
@property (copy,nonatomic) NSDictionary *count;



@end
