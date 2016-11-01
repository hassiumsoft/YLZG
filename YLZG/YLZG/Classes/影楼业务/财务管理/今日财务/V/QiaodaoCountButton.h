//
//  QiaodaoCountButton.h
//  YLZG
//
//  Created by Chan_Sir on 2016/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiaodaoCountButton : UIButton

@property (nonatomic, strong) UIImageView * leftImageV;
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UIImageView * rightImageV;

+ (instancetype)shareqiaodaocountBtn;

@end
