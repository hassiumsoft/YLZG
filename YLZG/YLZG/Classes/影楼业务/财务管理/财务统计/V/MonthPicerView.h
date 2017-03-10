//
//  MonthPicerView.h
//  YLZG
//
//  Created by Chan_Sir on 2017/3/10.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthPicerView : UIView

@property (copy,nonatomic) void (^SelectDateBlock)(NSString *selectDate);

@end
