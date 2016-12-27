//
//  UIImage+Category.h
//  FYQ
//
//  Created by Chan_Sir on 2016/12/19.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

/** 颜色生成图片 */
- (UIImage *)imageWithBgColor:(UIColor *)color;


/**
 图片高斯模糊

 @param image 图片
 @param blur 模糊值
 @return 返回的图片
 */
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
