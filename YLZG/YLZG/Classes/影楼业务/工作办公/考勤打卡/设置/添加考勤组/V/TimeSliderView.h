//
//  TimeSliderView.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/26.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeSliderView : UIView

- (void)addTarget:(id)target Action:(SEL)action;

@property (copy,nonatomic) NSString *timeTypeKey;

@property (assign,nonatomic) NSInteger indexPath;


@end
