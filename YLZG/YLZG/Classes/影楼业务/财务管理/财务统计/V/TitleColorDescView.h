//
//  TitleColorDescView.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/29.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleColorDescView : UIView

/** 文字 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 颜色 */
@property (strong,nonatomic) UIView *colorView;
/** 初始化 */
+ (instancetype)sharedTitleColorDescView;


@end
