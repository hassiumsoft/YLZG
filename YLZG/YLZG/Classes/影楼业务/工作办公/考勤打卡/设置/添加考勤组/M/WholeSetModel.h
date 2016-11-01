//
//  WholeSetModel.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/25.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WholeSetModel : NSObject
/** 旷工分钟数 */
@property (copy,nonatomic) NSString *absent;
/** 最早打开分钟数 */
@property (copy,nonatomic) NSString *earlytime;
/** 严重迟到分钟数 */
@property (copy,nonatomic) NSString *latetime;
/** 弹性分钟数 */
@property (copy,nonatomic) NSString *privilege_time;

/** 是否绑定审批 */
@property (assign,nonatomic) BOOL sply;

/** 下班tip */
@property (copy,nonatomic) NSString *offtip;
/** 上班tip */
@property (copy,nonatomic) NSString *ontip;
/** 外勤打卡通知 */
@property (assign,nonatomic) BOOL outtip;

@end
