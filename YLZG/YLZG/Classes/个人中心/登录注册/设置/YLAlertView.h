//
//  YLAlertView.h
//  YLZG
//
//  Created by apple on 2016/10/25.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLAlertView : UIAlertView


/**
 *  弹出提示框
 *
 *  @param title             标题
 *  @param message           消息
 *  @param block             描述
 *  @param cancelButtonTitle 取消描述
 *  @param otherButtonTitles 其他描述
 *
 *  @return 返回值
 */
+ (id)showAlertWithTitle:(NSString *)title
                 message:(NSString *)message
         completionBlock:(void (^)(NSUInteger buttonIndex, YLAlertView *alertView))block
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSString *)otherButtonTitles, ...;


@end
