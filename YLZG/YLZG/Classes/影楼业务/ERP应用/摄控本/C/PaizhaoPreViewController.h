//
//  PaizhaoPreViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/11.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@interface PaizhaoPreViewController : SuperViewController

/** 索引 */
@property (assign,nonatomic) NSInteger index;

/**
 获取数据

 @param dateStr 日期
 */
- (void)loadDataWithDate:(NSString *)dateStr;

@end
