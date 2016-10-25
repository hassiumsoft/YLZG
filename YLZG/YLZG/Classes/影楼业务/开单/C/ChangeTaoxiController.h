//
//  ChangeTaoxiController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"

@class TaoxiNamePrice;

@protocol changeTaoxiDelegate <NSObject>

- (void)changeTaoxiModel:(TaoxiNamePrice *)namePrice;

@end

@interface ChangeTaoxiController : SuperViewController

@property (weak,nonatomic) id<changeTaoxiDelegate> delegate;

@end
