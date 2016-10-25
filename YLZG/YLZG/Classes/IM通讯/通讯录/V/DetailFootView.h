//
//  DetailFootView.h
//  YLZG
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@interface DetailFootView : UIView
@property (strong,nonatomic) UIButton *messageBtn;
@property (strong,nonatomic) UIButton *phoneBtn;
+(instancetype)footerView;
@end
