//
//  DeptTeamKaoqinModel.h
//  NewHXDemo
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeptTeamKaoqinModel : NSObject

// 打卡状态的数组
@property (nonatomic, strong) NSArray * count;
// 部门名称
@property (nonatomic, copy) NSString * dept;
// 应到
@property (nonatomic, copy) NSString * should;
// 实到
@property (nonatomic, copy) NSString * infact;

// 所有员工
@property (nonatomic, copy) NSString * totalstaff;

@end
