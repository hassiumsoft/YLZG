//
//  GudingBanciVController.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/6/28.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"



/************ 固定班次 *************/


@protocol GudingBanciDelegate <NSObject>

- (void)gudingbanciWithJsonStr:(NSString *)jsonStr WithModelArray:(NSArray *)modelArray;

@end

@interface GudingBanciVController : SuperViewController

@property (weak,nonatomic) id<GudingBanciDelegate> delegate;

@end
