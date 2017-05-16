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
/** 标题 */
@property (copy,nonatomic) NSString *title;
/** 版本描述 */
@property (copy,nonatomic) NSString *content;
/** 推送图标 */
@property (copy,nonatomic) NSString *imageurl;
/** 日期 */
@property (copy,nonatomic) NSString *date;

@property (copy,nonatomic) NSString *extra;

@end
