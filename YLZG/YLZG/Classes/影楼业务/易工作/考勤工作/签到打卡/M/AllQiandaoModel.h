//
//  AllQiandaoModel.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 "head" : "http://files.parsetfss.com/9346bbf1-a67c-404d-9456-78ba9f83de5f/tfss-091711c8-13c8-45b6-a5a7-8f6b8e307b37-image.png",
 "nickname" : "喻泽",
 "realname" : "喻泽",
 "times" : 0,
 "uid" : "129
 */

@interface AllQiandaoModel : NSObject

// 头像
@property (nonatomic, copy) NSString * head;
// 昵称
@property (nonatomic, copy) NSString * nickname;
// 姓名
@property (nonatomic, copy) NSString * realname;
// 签到次数
@property (nonatomic, copy) NSString * times;
// 员工id
@property (nonatomic, copy) NSString * uid;

@end
