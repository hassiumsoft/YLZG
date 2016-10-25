//
//  DetailHeadView.h
//  YLZG
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactersModel.h"

@interface DetailHeadView : UIView

@property (strong,nonatomic) ContactersModel *model;

+ (instancetype)detailHeadView;

@end
