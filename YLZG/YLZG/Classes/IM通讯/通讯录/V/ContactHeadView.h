//
//  ContactHeadView.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactHeadView : UIView

/** 箭头→ */
@property (strong,nonatomic) UIImageView *jiantouV;
/** 部门名称 */
@property (strong,nonatomic) UILabel *deptLabel;
/** 部门人数 */
@property (strong,nonatomic) UILabel *memNumLabel;


+ (instancetype)sharedContactHeadView;

@end
