//
//  DateMineKaoqinPicker.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DateMineKaoqinPicker.h"
#import "UIView+Extension.h"

#define MONTH ( 1 )
#define YEAR ( 0 )
// Identifies for component views
#define LABEL_TAG 43

@interface DateMineKaoqinPicker ()

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIPickerView * datePicker;


@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;

@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger maxYear;

@end

@implementation DateMineKaoqinPicker

const NSInteger bigRowCount = 1000;
const NSInteger numberOfComponents = 2;

+ (instancetype)shareDateMineKaoqinPicker {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBACOLOR(79, 79, 100, 1);
        self.alpha = 0;
        [self setupSubViews];
        [self loadDefaultsParameters];
    }
    return self;
}

- (void)setupSubViews {
    [self addTarget:self action:@selector(removeMyself:) forControlEvents:UIControlEventTouchUpInside];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 188)];
    _backView.alpha = 0.2;
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    
    self.datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH, _backView.height-38)];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:self.datePicker];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
    topView.backgroundColor = RGBACOLOR(69, 86, 150, 1);
    topView.userInteractionEnabled = YES;
    [_backView addSubview:topView];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(10, 6, 40, 24);
    [leftBtn addTarget:self action:@selector(removeMyself:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH-50, 6, 40, 24);
    [rightBtn addTarget:self action:@selector(endPickClock:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:rightBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.y = SCREEN_HEIGHT-189;
        self.alpha = 0.9;
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 选择时间日期
- (void)endPickClock:(UIButton *)sender {
    
    if ([self.dvDelegate respondsToSelector:@selector(yearMonthDatePicker:didSelectedDate:)]) {
        [self.dvDelegate yearMonthDatePicker:self didSelectedDate:[self date]];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.y = SCREEN_HEIGHT;
        self.backView.alpha = 0.2;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [sender removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
    
}

- (void)removeMyself:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.y = SCREEN_HEIGHT;
        self.backView.alpha = 0.2;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [sender removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}


#pragma mark - Properties

-(void)setMonthFont:(UIFont *)monthFont
{
    if (monthFont)
    {
        _monthFont = monthFont;
    }
}

-(void)setMonthSelectedFont:(UIFont *)monthSelectedFont
{
    if (monthSelectedFont)
    {
        _monthSelectedFont = monthSelectedFont;
    }
}

-(void)setYearFont:(UIFont *)yearFont
{
    if (yearFont)
    {
        _yearFont = yearFont;
    }
}

-(void)setYearSelectedFont:(UIFont *)yearSelectedFont
{
    if (yearSelectedFont)
    {
        _yearSelectedFont = yearSelectedFont;
    }
}

#pragma mark - Init

-(instancetype)init
{
    if (self = [super init])
    {
        [self loadDefaultsParameters];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadDefaultsParameters];
}

#pragma mark - Open methods

-(NSDate *)date
{
    NSInteger monthCount = self.months.count;
    NSString *month = [self.months objectAtIndex:([self.datePicker selectedRowInComponent:MONTH] % monthCount)];
    
    NSInteger yearCount = self.years.count;
    NSString *year = [self.years objectAtIndex:([self.datePicker selectedRowInComponent:YEAR] % yearCount)];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年M月"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@%@", year, month]];
    return date;
}

- (void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear
{
    self.minYear = minYear;
    
    if (maxYear > minYear)
    {
        self.maxYear = maxYear;
    }
    else
    {
        self.maxYear = minYear + 10;
    }
    
    self.years = [self nameOfYears];
    self.todayIndexPath = [self todayPath];
}

-(void)selectToday
{
    [self.datePicker selectRow: self.todayIndexPath.row
        inComponent: MONTH
           animated: NO];
    
    [self.datePicker selectRow: self.todayIndexPath.section
        inComponent: YEAR
           animated: NO];
}

#pragma mark - UIPickerViewDelegate

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidth];
}

-(UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    BOOL selected = NO;
    if(component == MONTH)
    {
        NSInteger monthCount = self.months.count;
        NSString *monthName = [self.months objectAtIndex:(row % monthCount)];
        NSString *currentMonthName = [self currentMonthName];
        if([monthName isEqualToString:currentMonthName] == YES)
        {
            selected = YES;
        }
    }
    else
    {
        NSInteger yearCount = self.years.count;
        NSString *yearName = [self.years objectAtIndex:(row % yearCount)];
        NSString *currenrYearName  = [self currentYearName];
        if([yearName isEqualToString:currenrYearName] == YES)
        {
            selected = YES;
        }
    }
    
    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent:component];
    }
    
    returnView.font = selected ? [self selectedFontForComponent:component] : [self fontForComponent:component];
    returnView.textColor = selected ? [self selectedColorForComponent:component] : [self colorForComponent:component];
    
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.rowHeight;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        return [self bigRowMonthCount];
    }
    return [self bigRowYearCount];
}

#pragma mark - Util

-(NSInteger)bigRowMonthCount
{
    return self.months.count  * bigRowCount;
}

-(NSInteger)bigRowYearCount
{
    return self.years.count  * bigRowCount;
}

-(CGFloat)componentWidth
{
    return self.datePicker.bounds.size.width / numberOfComponents;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        NSInteger monthCount = self.months.count;
        return [self.months objectAtIndex:(row % monthCount)];
    }
    NSInteger yearCount = self.years.count;
    return [self.years objectAtIndex:(row % yearCount)];
}

-(UILabel *)labelForComponent:(NSInteger)component
{
    CGRect frame = CGRectMake(0, 0, [self componentWidth], self.rowHeight);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;    // UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    
    label.tag = LABEL_TAG;
    
    return label;
}

-(NSArray *)nameOfMonths
{
    return @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
}

-(NSArray *)nameOfYears
{
    NSMutableArray *years = [NSMutableArray array];
    
    for(NSInteger year = self.minYear; year <= self.maxYear; year++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%li年", (long)year];
        [years addObject:yearStr];
    }
    return years;
}

-(NSIndexPath *)todayPath // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self currentMonthName];
    NSString *year  = [self currentYearName];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            row = row + [self bigRowMonthCount] / 2;
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            section = section + [self bigRowYearCount] / 2;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

-(NSString *)currentMonthName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"M月"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentYearName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年"];
    return [formatter stringFromDate:[NSDate date]];
}

- (UIColor *)selectedColorForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthSelectedTextColor;
    }
    return self.yearSelectedTextColor;
}

- (UIColor *)colorForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthTextColor;
    }
    return self.yearTextColor;
}

- (UIFont *)selectedFontForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthSelectedFont;
    }
    return self.yearSelectedFont;
}

- (UIFont *)fontForComponent:(NSInteger)component
{
    if (component == 1)
    {
        return self.monthFont;
    }
    return self.yearFont;
}

-(void)loadDefaultsParameters
{
    self.minYear = 2008;
    self.maxYear = 2030;
    self.rowHeight = 44;
    
    self.months = [self nameOfMonths];
    self.years = [self nameOfYears];
    self.todayIndexPath = [self todayPath];
    
    self.datePicker.delegate = self;
    self.datePicker.dataSource = self;
    
    [self selectToday];
    
    self.monthSelectedTextColor = [UIColor blackColor];
    self.monthTextColor = [UIColor blackColor];
    
    self.yearSelectedTextColor = [UIColor blackColor];
    self.yearTextColor = [UIColor blackColor];
    
    self.monthSelectedFont = [UIFont systemFontOfSize:17];
    self.monthFont = [UIFont systemFontOfSize:17];
    
    self.yearSelectedFont = [UIFont systemFontOfSize:17];
    self.yearFont = [UIFont systemFontOfSize:17];
}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    
//    if ([self.dvDelegate respondsToSelector:@selector(yearMonthDatePicker:didSelectedDate:)]) {
//        [self.dvDelegate yearMonthDatePicker:self didSelectedDate:[self date]];
//    }
//    
//}

- (void)selectDate:(NSDate *)date{
    
    NSIndexPath *selectIndexPath = [self selectPathWithDate:date];
    
    [self.datePicker selectRow: selectIndexPath.row
        inComponent: MONTH
           animated: NO];
    
    [self.datePicker selectRow: selectIndexPath.section
        inComponent: YEAR
           animated: NO];
    
    [self pickerView:self.datePicker didSelectRow:selectIndexPath.row inComponent:MONTH];
    [self pickerView:self.datePicker didSelectRow:selectIndexPath.row inComponent:YEAR];
}


-(NSString *)selectMonthName:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"M月"];
    return [formatter stringFromDate:date];
}

-(NSString *)selectYearName:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年"];
    return [formatter stringFromDate:date];
}

-(NSIndexPath *)selectPathWithDate:(NSDate *)date // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self selectMonthName:date];
    NSString *year  = [self selectYearName:date];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            row = row + [self bigRowMonthCount] / 2;
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            section = section + [self bigRowYearCount] / 2;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}


@end
