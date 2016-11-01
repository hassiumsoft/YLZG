//
//  SendLocationModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendLocationModel : NSObject

@property (assign,nonatomic) double latitude;

@property (assign,nonatomic) double longitude;

@property (copy,nonatomic) NSString *address;

@end
