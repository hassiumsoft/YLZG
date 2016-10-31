/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseMessageTimeCell.h"
#import <Masonry.h>


@implementation EaseMessageTimeCell

+ (instancetype)shatedEaseMessageTimeCell:(UITableView *)tableView
{
    static NSString *ID = @"EaseMessageTimeCell";
    EaseMessageTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EaseMessageTimeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
     }
    return cell;
}

- (void)setTime:(NSString *)time
{
    _timeLabel.text = time;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = [UIColor clearColor];
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.backgroundColor = [UIColor lightGrayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:11];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.layer.masksToBounds = YES;
        self.timeLabel.layer.cornerRadius = 4.f;
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@20);
        }];

    }
    return self;
}

@end
