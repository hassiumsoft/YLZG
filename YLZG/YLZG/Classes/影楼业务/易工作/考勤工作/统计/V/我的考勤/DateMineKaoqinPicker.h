//
//  DateMineKaoqinPicker.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateMineKaoqinPicker;

@protocol DateMineKaoqinPickerDelegate <NSObject>
@optional
- (void)yearMonthDatePicker:(DateMineKaoqinPicker *)yearMonthDatePicker didSelectedDate:(NSDate *)date;

@end

@interface DateMineKaoqinPicker : UIButton<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) id<DateMineKaoqinPickerDelegate> dvDelegate;

@property (nonatomic, strong) UIColor *monthSelectedTextColor;
@property (nonatomic, strong) UIColor *monthTextColor;

@property (nonatomic, strong) UIColor *yearSelectedTextColor;
@property (nonatomic, strong) UIColor *yearTextColor;

@property (nonatomic, strong) UIFont *monthSelectedFont;
@property (nonatomic, strong) UIFont *monthFont;

@property (nonatomic, strong) UIFont *yearSelectedFont;
@property (nonatomic, strong) UIFont *yearFont;

@property (nonatomic, assign) NSInteger rowHeight;


/**
 *  查看datePicker当前选择的日期
 */
@property (nonatomic, strong, readonly) NSDate *date;

/**
 *  datePicker显示今天
 */
-(void)selectToday;

/**
 *  datePicker显示date
 */
- (void)selectDate:(NSDate *)date;

/**
 *  datePicker设置最小年份和最大年份
 */
-(void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear;

+ (instancetype)shareDateMineKaoqinPicker;

@end
