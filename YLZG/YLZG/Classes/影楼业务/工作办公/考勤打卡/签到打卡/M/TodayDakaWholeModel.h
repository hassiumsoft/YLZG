//
//  TodayDakaWholeModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayDakaWholeModel : NSObject

/** 迟到多少分钟算缺席 */
@property (copy,nonatomic) NSString *absent;
/** 最早打卡分钟数 */
@property (copy,nonatomic) NSString *earlytime;
/** 严重迟到分钟数 */
@property (copy,nonatomic) NSString *latetime;
/** 下班打卡提醒--延迟几分钟 */
@property (copy,nonatomic) NSString *offtip;
/** 下班打卡提醒--提前几分钟 */
@property (copy,nonatomic) NSString *outtip;
/** 弹性分钟数 */
@property (copy,nonatomic) NSString *privilege_time;
/** 是否绑定审批 */
@property (assign,nonatomic) BOOL sply;


@end
