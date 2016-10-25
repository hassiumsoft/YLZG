//
//  ChooseBanciVController.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/6/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "BanciModel.h"

@protocol ChooseBanciDelegate <NSObject>

/** 固定班制时单选某个班次 */
- (void)chooseOneBanciWithModel:(BanciModel *)model;
/** 排班制时可选多个班次 */
- (void)chooseMoreBanciWithArray:(NSArray *)modelAray;

@end

@interface ChooseBanciVController : SuperViewController

@property (copy,nonatomic) NSString *type; // 固定还是弹性制

@property (weak,nonatomic) id<ChooseBanciDelegate> delegate;

@end
