//
//  AllMembersController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"
#import "YLGroup.h"

@interface AllMembersController : SuperViewController

@property (copy,nonatomic) NSArray *memberArr;

@property (copy,nonatomic) void (^DidSelectBlock)(NSIndexPath *indexPath);

- (void)reloadData;

@property (strong,nonatomic) YLGroup *groupModel;


@end
