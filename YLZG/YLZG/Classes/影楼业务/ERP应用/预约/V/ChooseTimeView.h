//
//  ChooseTimeView.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectTime)(NSString *time);

/** 选择时间的视图 */
@interface ChooseTimeView : UIView

+ (instancetype)sharedChooseTimeView;

@property (copy,nonatomic) void (^DidSelectTime)();

@end
