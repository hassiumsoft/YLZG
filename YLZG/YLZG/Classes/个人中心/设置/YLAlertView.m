//
//  YLAlertView.m
//  YLZG
//
//  Created by apple on 2016/10/25.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "YLAlertView.h"

#import <objc/runtime.h>




@interface YLAlertView ()<UIAlertViewDelegate>

@end

@implementation YLAlertView

void EMNoTitleAlert(NSString* message) {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (id)showAlertWithTitle:(NSString *)title message:(NSString *)message
         completionBlock:(void (^)(NSUInteger buttonIndex, YLAlertView *alertView))block
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (!cancelButtonTitle && !otherButtonTitles) {
        return nil;
    }
    YLAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                         completionBlock:block
                                       cancelButtonTitle:cancelButtonTitle
                                       otherButtonTitles:nil];
    
    if (otherButtonTitles != nil) {
        id eachObject;
        va_list argumentList;
        if (otherButtonTitles) {
            [alertView addButtonWithTitle:otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [alertView addButtonWithTitle:eachObject];
            }
            va_end(argumentList);
        }
    }
    
    [alertView show];
    
    return alertView;
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^block)(NSUInteger buttonIndex, UIAlertView *alertView) = objc_getAssociatedObject(self, "blockCallback");
    if (block) {
        block(buttonIndex, self);
    }
}


- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
    completionBlock:(void (^)(NSUInteger buttonIndex,YLAlertView *alertView))block
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    objc_setAssociatedObject(self, "blockCallback", [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self = [self initWithTitle:title
                           message:message
                          delegate:self
                 cancelButtonTitle:nil
                 otherButtonTitles:nil]) {
        
        if (cancelButtonTitle) {
            [self addButtonWithTitle:cancelButtonTitle];
            self.cancelButtonIndex = [self numberOfButtons] - 1;
        }
        
        id eachObject;
        va_list argumentList;
        if (otherButtonTitles) {
            [self addButtonWithTitle:otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [self addButtonWithTitle:eachObject];
            }
            va_end(argumentList);
        }
    }
    return self;
}

@end
