//
//  SaleToolModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/3.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaleToolModel : NSObject

/** 工具ID */
@property (copy,nonatomic) NSString *id;
/** H5页面地址 */
@property (copy,nonatomic) NSString *content;
/** 图标地址 */
@property (copy,nonatomic) NSString *ico;
/** 简短说明 */
@property (copy,nonatomic) NSString *remarks;
/** 工具名称 */
@property (copy,nonatomic) NSString *name;


@end
