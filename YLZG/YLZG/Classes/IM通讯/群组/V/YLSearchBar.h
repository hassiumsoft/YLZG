//
//  YLSearchBar.h
//  YLZG
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLSearchBar : UISearchBar

/**
 *  自定义控件自带的取消按钮的文字（默认为“取消”/“Cancel”）
 *
 *  @param title 自定义文字
 */
- (void)setCancelButtonTitle:(NSString *)title;


@end
