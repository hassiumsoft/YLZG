//
//  TeamZhengchangdakaModel.h
//  NewHXDemo
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamZhengchangdakaModel : NSObject

/**
 * "checkin" : {},
 "dept" : "门市部",
 "head" : "http://files.parsetfss.com/9346bbf1-a67c-404d-9456-78ba9f83de5f/tfss-dc532adc-c44b-4f4d-b140-b8f5973e3470-file",
 "mark" : "",
 "nickname" : "莎莎",
 "realname" : "莎莎",
 "rule" : {
 "classid" : "14",
 "classname" : "班次C",
 "end" : "21:14",
 "start" : "09:14"
 },
 "uid" : "1"
 */

@property (nonatomic, copy) NSString * checkin;
@property (nonatomic, copy) NSString * dept;
@property (nonatomic, copy) NSString * head;
@property (nonatomic, copy) NSString * mark;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * realname;
@property (nonatomic, copy) NSDictionary * rule;
@property (nonatomic, copy) NSString * uid;

@end
