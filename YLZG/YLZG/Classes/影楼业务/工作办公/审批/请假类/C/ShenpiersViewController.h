//
//  ShenpiersViewController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/20.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"
#import "StaffInfoModel.h"

@protocol ShenpiDelegate <NSObject>

- (void)shenpiDelegate:(StaffInfoModel *)model;

@end

@interface ShenpiersViewController : SuperViewController

@property (weak,nonatomic) id<ShenpiDelegate> delegate;

@end
