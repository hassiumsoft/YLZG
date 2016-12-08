//
//  ZhuanfaCountModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/7.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhuanfaListModel.h"


/** 转发统计模型 */

@interface ZhuanfaCountModel : NSObject

/** 已转发人数 */
@property (copy,nonatomic) NSString *done;
/** 未转发人数 */
@property (copy,nonatomic) NSString *dont;
/** 团队人数 */
@property (copy,nonatomic) NSString *all;
/** 转发人数详情列表 */
@property (copy,nonatomic) NSArray *personlist;


@end
