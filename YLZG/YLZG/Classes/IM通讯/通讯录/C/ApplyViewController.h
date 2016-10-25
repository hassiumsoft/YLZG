//
//  ApplyViewController.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

typedef enum{
    YLApplyStyleFriend            = 0,
    YLApplyStyleGroupInvitation,
    YLApplyStyleJoinGroup,
}YLApplyStyle;

@interface ApplyViewController : SuperViewController

@property (strong, nonatomic) NSMutableArray *dataSource;

+ (instancetype)shareController;


@end
