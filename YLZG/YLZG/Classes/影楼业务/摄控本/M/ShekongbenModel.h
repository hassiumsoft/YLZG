//
//  ShekongbenModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/11.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShekongbenModel : NSObject

/** 顾客 */
@property (nonatomic, copy) NSString * guest;
/** 家长电话 */
@property (nonatomic, copy) NSString * paphone;
/** 套系价格 */
@property (nonatomic, copy) NSString * set_price;
/** 套系名称 */
@property (nonatomic, copy) NSString * set_name;
/** 门市 */
@property (nonatomic, copy) NSString * store;
/** 时间 */
@property (nonatomic, copy) NSString * time;
/** 工作类型 */
@property (nonatomic, copy) NSString * type;


// 拍照
/** 引导助理 */
@property (nonatomic, copy) NSString * gassister;

/** 景点 */
@property (nonatomic, copy) NSString * vspot;

/** 摄影师 */
@property (nonatomic, copy) NSString * pger;

/** 摄影师助理 */
@property (nonatomic, copy) NSString * pgassister;

/** 引导人 */
@property (nonatomic, copy) NSString * guide;

/** 选片 和 看样 */
/** 看样人 */
@property (nonatomic, copy) NSString * waitor;

// 取件
/** 制作是否完成 */
@property (nonatomic, copy) NSString * isok;


@end
