//
//  MonthInComeController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/2.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "SuperViewController.h"
#import "InComeModel.h"

@interface MonthInComeController : SuperViewController

@property (assign,nonatomic) NSUInteger index;

@property (strong,nonatomic) InComeModel *inModel;

@property (copy,nonatomic) NSString *month;

- (void)reloadData;

@end
