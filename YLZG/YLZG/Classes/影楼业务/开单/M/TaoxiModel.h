//
//  TaoxiModel.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/9.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaoxiNamePrice.h"

/** 获取母套系名称和子套系数组 */

@interface TaoxiModel : NSObject

/** 子套系 */
@property (strong,nonatomic) NSArray *child_set;
/** 大套系名称 */
@property (copy,nonatomic) NSString *set;
/** 子套系的个数 */
@property (copy,nonatomic) NSString *nums;


@end
