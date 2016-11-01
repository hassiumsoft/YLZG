//
//  MineKaoqinTableViewCell.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MineKaoqinTableViewCell.h"

@implementation MineKaoqinTableViewCell

+ (instancetype)sharedMineKaoqinTableViewCell:(UITableView *)tableView {
    static NSString * ID = @"MineKaoqinTableViewCell";
    MineKaoqinTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MineKaoqinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self createCell];
    }
    return self;
}

- (void)createCell {
    UILabel * grayLine = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 0.5, 64)];
    grayLine.backgroundColor = RGBACOLOR(196, 196, 196, 1);
    [self.contentView addSubview:grayLine];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(grayLine.frame)+20, 0, 150, 34)];
    _dateLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_dateLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dateLabel.frame)+10, CGRectGetMinY(_dateLabel.frame)+5, 100, 20)];
    _timeLabel.backgroundColor = [UIColor orangeColor];
    _timeLabel.layer.masksToBounds = YES;
    _timeLabel.layer.cornerRadius = 10;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
}


@end
