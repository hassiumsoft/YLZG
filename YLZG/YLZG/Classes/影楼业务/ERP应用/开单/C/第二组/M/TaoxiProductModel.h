//
//  TaoxiProductModel.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/17.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <Foundation/Foundation.h>

/******** 套系产品名称 ********/

@interface TaoxiProductModel : NSObject

/** 产品名称 */
@property (copy,nonatomic) NSString *pro_name;
/** 产品价格 */
@property (copy,nonatomic) NSString *pro_price;
/** 产品数量 */
@property (assign,nonatomic) int number;
/** category */
@property (copy,nonatomic) NSString *category;
/** 是否加急 */
@property (copy,nonatomic) NSString *isUrgent;
/** 加急时间 */
@property (copy,nonatomic) NSString *urgentTime;


/********** IndexPath.section **********/
@property (assign,nonatomic) NSInteger section;

@end
