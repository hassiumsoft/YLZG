//
//  ChooseAdminsController.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/6/28.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

@protocol ChooseAdminDelegate <NSObject>

- (void)chooseAdminWithArray:(NSArray *)adminArrar;

@end

@interface ChooseAdminsController : SuperViewController

@property (weak,nonatomic) id<ChooseAdminDelegate> delegate;

@end
