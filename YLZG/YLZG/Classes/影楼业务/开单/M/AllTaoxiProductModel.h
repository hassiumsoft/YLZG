//
//  AllTaoxiProductModel.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/19.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaoxiProductModel.h"


/** 当没有套系时返回全部套系下的全部产品 */

@interface AllTaoxiProductModel : NSObject

/** 套系下的产品 */
@property (copy,nonatomic) NSArray *productList;
/** 数量 */
@property (assign,nonatomic) int nums;
/** 套系名称 */
@property (copy,nonatomic) NSString *set;

@end
