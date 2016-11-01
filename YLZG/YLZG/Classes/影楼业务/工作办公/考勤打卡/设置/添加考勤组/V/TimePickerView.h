//
//  TimePickerView.h
//  NewHXDemo
//
//  Created by Chan_Sir on 16/6/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ShangbanTimeType) {
    StartTime = 1,
    EndTime = 2
};



/********** 直选时间的 ***********/

@interface TimePickerView : UIView

@property (assign,nonatomic) ShangbanTimeType timeType;

//- (instancetype)initWithFrame:(CGRect)frame DateTimeMode:(NSInteger)pickerMode;

+ (instancetype)sharedTimePickerView;

@end
