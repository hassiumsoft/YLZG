//
//  SendLocaltionController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "SendLocationModel.h"


typedef void(^SendLocalBlock)(SendLocationModel *model);

@interface SendLocaltionController : SuperViewController

@property (copy,nonatomic) void (^SendLocalBlock)();

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate;


@end
