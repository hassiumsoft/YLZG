//
//  OrderPhoneController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"

@protocol OrderPhoneDelegate <NSObject>

- (void)orderCusPhone:(NSString *)phoneNum;

@end

@interface OrderPhoneController : SuperViewController

@property (copy,nonatomic) void (^PhoneBlock)(NSString *phone2);

@property (weak,nonatomic) id<OrderPhoneDelegate> delegate;

@end
