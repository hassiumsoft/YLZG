//
//  NoticeDetialView.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"

@interface NoticeDetialView : UIView

@property (strong,nonatomic) NoticeModel *model;

+ (instancetype)sharedNoticeDetialView;

@end
