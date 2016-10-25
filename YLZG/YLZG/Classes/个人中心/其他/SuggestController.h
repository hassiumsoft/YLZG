//
//  SuggestController.h
//  佛友圈
//
//  Created by Chan_Sir on 16/1/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuggestController.h"

typedef NS_ENUM(NSInteger,SuggestClass) {
    SuggestType = 1,
    BugType = 2
};

@interface SuggestController : UIViewController

@property (assign,nonatomic) SuggestClass type;

@end
