//
//  GroupMemberView.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GroupMemberView : UIView


@property (copy,nonatomic) NSArray *memberArr;

@property (copy,nonatomic) void (^DidSelectBlock)(NSIndexPath *indexPath);

- (void)reloadData;

@end
