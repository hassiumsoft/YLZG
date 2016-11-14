//
//  MyjobModel.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//
/**
 // 相同部分
 "guest" : "黄越梦/李紫怡",
 "maphone" : "15559982295",
 "paphone" : "",
 "set_name" : "合作医院周岁",
 "set_price" : "0",
 "store" : "程程",
 "time" : "2016-06-03 11:00",
 "type" : 1,
 "waitor" : "张娟"
 
 // 不同部分
    balance  余款（是否欠款）
	vspot   景点
	pger   摄影师
	pgassister  摄影师助理
	guide  引导人
	gassister  引导助理
    deadline 完成期限
    isok 制作是否完成
 
 */
#import <Foundation/Foundation.h>

@interface MyjobModel : NSObject

/** 相同部分 */
// 顾客姓名
@property (nonatomic, copy) NSString * guest;
// 家长手机号
@property (nonatomic, copy) NSString * paphone;
// 套系名称
@property (nonatomic, copy) NSString * set_name;
// 套系价格
@property (nonatomic, copy) NSString * set_price;
// 门市
@property (nonatomic, copy) NSString * store;
// 时间
@property (nonatomic, copy) NSString * time;
// 类型
@property (nonatomic, copy) NSString * type;
// 选片人
@property (nonatomic, copy) NSString * waitor;




/** 不同部分 */
// 余款（是否欠款）
@property (nonatomic, copy) NSString * balance;
// 景点
@property (nonatomic, copy) NSString * vspot;
// 摄影师
@property (nonatomic, copy) NSString * pger;
// 摄影师助理
@property (nonatomic, copy) NSString * pgassister;
// 引导人
@property (nonatomic, copy) NSString * guide;
// 引导助理
@property (nonatomic, copy) NSString * gassister;
// 完成期限
@property (nonatomic, copy) NSString * deadline;
// 制作是否完成
@property (nonatomic, copy) NSString * isok;


@end
