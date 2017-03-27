//
//  TeamClassModel.h
//  YLZG
//
//  Created by Chan_Sir on 2017/3/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamClassModel : NSObject

/** 是否为新添加 */
@property (assign,nonatomic) BOOL isNewAdd;

@property (copy,nonatomic) NSString *id;

@property (copy,nonatomic) NSString *name;

@end
