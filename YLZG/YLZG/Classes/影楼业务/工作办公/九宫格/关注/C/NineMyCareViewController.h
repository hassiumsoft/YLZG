//
//  NineMyCareViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/2.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "MobanListModel.h"

@interface NineMyCareViewController : SuperViewController

@property (strong,nonatomic) MobanListModel *listModel;

- (void)getData;

@end
