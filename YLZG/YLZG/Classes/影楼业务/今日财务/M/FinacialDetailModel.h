//
//  FinacialDetailModel.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//
/**
 "info" : "预约补款：20100511-003;张三;客户:zsls,王五",
 "money" : "1000",
 "payee" : ">管理员",
 "time" : "2016-01-23 14:41:45"
 */

#import <Foundation/Foundation.h>

@interface FinacialDetailModel : NSObject

@property (nonatomic, copy) NSString * info;
@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * payee;
@property (nonatomic, copy) NSString * time;


@end
