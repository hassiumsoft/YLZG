//
//  ChangeOrderPriceController.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"


@protocol ChangeOrderPriceDelegate <NSObject>

- (void)changeOrderPrice:(NSString *)changedPrice;

@end

@interface ChangeOrderPriceController : SuperViewController

@property (copy,nonatomic) NSString *price;

@property (weak,nonatomic) id<ChangeOrderPriceDelegate> delegate;

@end
