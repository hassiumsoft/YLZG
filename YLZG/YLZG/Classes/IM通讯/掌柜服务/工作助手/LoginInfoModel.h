//
//  LoginInfoModel.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfoModel : NSObject

/** 链接 */
@property (copy,nonatomic) NSString *url;
/** ID */
@property (copy,nonatomic) NSString *id;
/** 标题 */
@property (copy,nonatomic) NSString *title;
/** 描述 */
@property (copy,nonatomic) NSString *content;
/** 未登录人数 */
@property (copy,nonatomic) NSString *not_login;


@end
