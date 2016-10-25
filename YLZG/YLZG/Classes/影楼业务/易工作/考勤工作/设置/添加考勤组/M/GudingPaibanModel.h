//
//  GudingPaibanModel.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/6/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

/************** 固定排版模型 **************/

@interface GudingPaibanModel : NSObject

/** 班次名称 */
@property (copy,nonatomic) NSString *classname;
/** 上班时间 */
@property (copy,nonatomic) NSString *start;
/** 下班时间 */
@property (copy,nonatomic) NSString *end;
/** 星期几 */
@property (copy,nonatomic) NSString *week;
/** 班次ID */
@property (copy,nonatomic) NSString *classid;

/** 第几行 */
@property (assign,nonatomic) NSInteger index;

/** 是否选中 */
@property (assign,nonatomic) BOOL isSelected;


@end
