//
//  ButtonIconModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,IconComeFrom) {
    FromLocal = 0,
    FromWebSite = 1
};

@interface ButtonIconModel : NSObject

/** 区分是本地图标名称还是网络图片地址 */
@property (assign,nonatomic) IconComeFrom fromType;

/** id */
@property (copy,nonatomic) NSString *id;
/** 图标地址 */
@property (copy,nonatomic) NSString *ico;
/** 图标名字 */
@property (copy,nonatomic) NSString *name;

@end
