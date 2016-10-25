//
//  AllQiaodaoDetailModel.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 "head" : "http://files.parsetfss.com/9346bbf1-a67c-404d-9456-78ba9f83de5f/tfss-638f8e1a-5095-4b45-967e-2e663ec93116-file",
 "id" : "380",
 "intime" : "1465175408",
 "location" : "(null)",
 "location_x" : "39.9052",
 "location_y" : "116.3904",
 "nickname" : "张娟",
 "realname" : "张娟",
 "sid" : "9",
 "uid" : "151"
 */

#import <Foundation/Foundation.h>

@interface AllQiaodaoDetailModel : NSObject

// 头像
@property (nonatomic, copy) NSString * head;

@property (nonatomic, copy) NSString * id;
// 签到时间
@property (nonatomic, copy) NSString * intime;
// 地点x
@property (nonatomic, copy) NSString * location_x;
// 地点y
@property (nonatomic, copy) NSString * location_y;
// 昵称
@property (nonatomic, copy) NSString * nickname;
// 真实姓名
@property (nonatomic, copy) NSString * realname;

@property (nonatomic, copy) NSString * sid;
@property (nonatomic, copy) NSString * uid;

@end
