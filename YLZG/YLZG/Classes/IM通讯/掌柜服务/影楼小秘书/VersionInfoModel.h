//
//  VersionInfoModel.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionInfoModel : NSObject
/** ID */
@property (copy,nonatomic) NSString *id;
/** 1：图文   2 ： 图片    3：文字 */
@property (assign,nonatomic) int type;
/** 1：公共的  2： 客户发送  3：服务器回复 */
@property (assign,nonatomic) int from;
/** 标题 */
@property (copy,nonatomic) NSString *title;
/** 版本描述 */
@property (copy,nonatomic) NSString *content;
/** 推送图标 */
@property (copy,nonatomic) NSString *imageurl;
/** 日期 */
@property (copy,nonatomic) NSString *date;
/** 网页地址 */
@property (copy,nonatomic) NSString *extra;

@end
