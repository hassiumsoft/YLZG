//
//  DongtaiListModel.h
//  YLZG
//
//  Created by Chan_Sir on 2017/1/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
#import "TodayDongtaiModel.h"

@interface DongtaiListModel : NSObject

/** 时间日期 */
@property (copy,nonatomic) NSString *date;
/** pid */
@property (copy,nonatomic) NSString *pid;
/** project */
@property (copy,nonatomic) NSString *project;

/** 当天的动态列表 */
@property (copy,nonatomic) NSArray *lists;

@end
