//
//  MonthOutComeController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/2.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "SuperViewController.h"
#import "OutComeModel.h"

@interface MonthOutComeController : SuperViewController

@property (strong,nonatomic) OutComeModel *outModel;

@property (copy,nonatomic) NSString *month;

- (void)reloadData;

@end
