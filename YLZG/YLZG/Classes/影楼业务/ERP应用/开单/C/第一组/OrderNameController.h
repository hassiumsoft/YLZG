//
//  OrderNameController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"

@protocol OrderNameDelegate <NSObject>

- (void)orderCusName:(NSString *)cusName;

@end

@interface OrderNameController : SuperViewController

@property (copy,nonatomic) void (^NameBlock)(NSString *name2);

@property (weak,nonatomic) id<OrderNameDelegate> delegate;

@end
