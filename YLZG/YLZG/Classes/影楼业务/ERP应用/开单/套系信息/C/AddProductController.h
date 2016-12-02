//
//  AddProductController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/17.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperViewController.h"
#import "AllProductList.h"


/******* 添加套系产品 ********/

@interface AddProductController : SuperViewController

@property (copy,nonatomic) void (^DidBlock)(AllProductList *model);

@end
