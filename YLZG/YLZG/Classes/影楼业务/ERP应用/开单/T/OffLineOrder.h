//
//  OffLineOrder.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/23.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <Foundation/Foundation.h>

/********* 离线订单模型 *********/

@interface OffLineOrder : NSObject


@property (assign,nonatomic) int id;  // 数据的ID，方便删除或查询

/** 完整的URL */
@property (copy,nonatomic) NSString *allUrl;
/** 产品信息,二维数组打成json字符串 */
@property (copy,nonatomic) NSString *productlist;

/** 客人姓名 */
@property (copy,nonatomic) NSString *guest;
/** 客人电话 */
@property (copy,nonatomic) NSString *mobile;
/** 套系名称 */
@property (copy,nonatomic) NSString *set;
/** 套系价格 */
@property (copy,nonatomic) NSString *price;
/** 备注 */
@property (copy,nonatomic) NSString *msg;
/** 景点 */
@property (copy,nonatomic) NSString *spot;

/** 保存时间 */
@property (copy,nonatomic) NSString *saveTime;
/** 是否选中 */
@property (assign,nonatomic) BOOL isSelectedSend;



@end
