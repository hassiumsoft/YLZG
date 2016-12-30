//
//  TaskInputView.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/24.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskInputView : UIView

- (instancetype)initWithFrame:(CGRect)frame DidClick:(void (^)(NSString *contentStr))block;

@end
