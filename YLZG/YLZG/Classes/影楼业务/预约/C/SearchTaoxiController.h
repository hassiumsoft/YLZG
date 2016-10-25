//
//  SearchTaoxiController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/10.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"
#import "SearchViewModel.h"
#import "SearchOrderModel.h"

@protocol SearOrderDelegate <NSObject>

@optional
- (void)searchOrderModel:(SearchViewModel *)model;
- (void)detialOrderModel:(SearchOrderModel *)model;

@end

@interface SearchTaoxiController : SuperViewController

/** 代理 */
@property (weak,nonatomic) id<SearOrderDelegate> delegate;

@end
