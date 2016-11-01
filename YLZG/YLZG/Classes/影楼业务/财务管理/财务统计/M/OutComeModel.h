//
//  OutComeModel.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/29.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <Foundation/Foundation.h>

/********* 支出模型 *********/

@interface OutComeModel : NSObject

@property (assign,nonatomic) BOOL isPresent; // 是否为百分比格式

/** 总支出 */
@property (copy,nonatomic) NSString *totalout;
/** 办公用品 */
@property (copy,nonatomic) NSString *office;
/** 油费 */
@property (copy,nonatomic) NSString *oil;
/** 工资 */
@property (copy,nonatomic) NSString *salary;
/** 水电费 */
@property (copy,nonatomic) NSString *water;
/** 房租 */
@property (copy,nonatomic) NSString *rent;
/** 生活费 */
@property (copy,nonatomic) NSString *live;


@end
