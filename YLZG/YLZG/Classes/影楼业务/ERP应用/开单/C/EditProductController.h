//
//  EditProductController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"

@protocol EditProductDelegate <NSObject>

- (void)editProductArray:(NSArray *)productlist;

@end

@interface EditProductController : SuperViewController

/** 套系名称 */
@property (copy,nonatomic) NSString *taoName;
/** 是否为全部， */
@property (assign,nonatomic) BOOL isAllProduct;
/** 数据源 */
@property (strong,nonatomic) NSMutableArray *array;

@property (weak,nonatomic) id<EditProductDelegate> delegate;

@end
