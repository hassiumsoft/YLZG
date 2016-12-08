//
//  MyMobanModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMobanModel : NSObject

/** 模板类型 */
@property (copy,nonatomic) NSString *category;
/** 日期信息 */
@property (copy,nonatomic) NSString *date;
/** 模板ID */
@property (copy,nonatomic) NSString *id;
/** 模板名 */
@property (copy,nonatomic) NSString *name;
/** 缩略图 */
@property (copy,nonatomic) NSString *thumb;
/** 转发次数 */
@property (copy,nonatomic) NSString *times;
/** 我是否使用  0未使用 1已使用 */
@property (assign,nonatomic) BOOL useis;
/** 有多少人转发过 */
@property (copy,nonatomic) NSString *users;



@end
