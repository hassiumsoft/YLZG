//
//  TaskRecordTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/28.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskRecordTableCell.h"
#import <Masonry.h>


@interface TaskRecordTableCell ()

@property (strong,nonatomic) UILabel *label;

@end

@implementation TaskRecordTableCell

+ (instancetype)sharedTaskRecordTableCell:(UITableView *)tableView
{
    static NSString *ID = @"TaskRecordTableCell";
    TaskRecordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TaskRecordTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}
- (void)setDynamicModel:(TaskDetialDynamicModel *)dynamicModel
{
    _dynamicModel = dynamicModel;
    _label.text = [NSString stringWithFormat:@"%@ %@",[self timeIntervalToDate:dynamicModel.time],dynamicModel.content];
}

- (void)setupSubViews
{
    self.backgroundColor = NorMalBackGroudColor;
    self.label = [[UILabel alloc]init];
    self.label.numberOfLines = 2;
    self.label.font = [UIFont systemFontOfSize:11];
    self.label.textColor = [UIColor lightGrayColor];
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@21);
    }];
}

- (NSString *)timeIntervalToDate:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    if ([date isToday]) {
        return @"今天";
    }else{
        NSString *origanStr = [NSString stringWithFormat:@"%@",date];
        NSString *time = [origanStr substringWithRange:NSMakeRange(5, 11)];
        return time;
    }
    
}

@end
