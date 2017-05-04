//
//  SearchContacterController.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/2.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchContacterController : UITableViewController

/** 搜索出来的数据源 */
@property (copy,nonatomic) NSArray *searchArray;
/** 点击选择回调 */
@property (copy,nonatomic) void (^(ClickUserBlock))(ContactersModel *model);

@end
