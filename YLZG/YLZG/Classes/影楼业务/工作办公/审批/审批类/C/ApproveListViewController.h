//
//  ApproveListViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"


typedef void(^RefreshData)(NSArray *newArray);

@interface ApproveListViewController : SuperViewController

@property (assign,nonatomic) NSInteger index;

/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

@property (copy,nonatomic) void (^RefreshData)(NSArray *newArray);


@end
