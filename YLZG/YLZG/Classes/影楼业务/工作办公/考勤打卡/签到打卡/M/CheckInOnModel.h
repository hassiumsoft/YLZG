//
//  CheckInOnModel.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CheckInOnModel : NSObject

@property (copy,nonatomic) NSString *id;

@property (copy,nonatomic) NSString *img;

/** address,latitude,longitude */
@property (copy,nonatomic) NSDictionary *location;

@property (copy,nonatomic) NSString *mark;

@property (copy,nonatomic) NSString *outside;

@property (copy,nonatomic) NSString *remark;

@property (copy,nonatomic) NSString *router;

@property (copy,nonatomic) NSString *status;

@property (copy,nonatomic) NSString *time;


@end
