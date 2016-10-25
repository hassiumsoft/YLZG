//
//  FinancialDetailCell.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FinancialDetailCell.h"
#import <Masonry.h>

@implementation FinancialDetailCell

+ (instancetype)sharedFinancialDetailCell:(UITableView *)tableView
{
    static NSString *ID = @"FinancialDetailCell";
    FinancialDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FinancialDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCell];
    }
    return self;
}


- (void)setModel:(FinacialDetailModel *)model {
    _model = model;
    _timeLabel.text = model.time;
    _guestLabel.text = model.info;
    NSString *str  = [NSString stringWithFormat:@"¥%@",model.money];
    _moneyLabel.text = str;
}

- (void)createCell {
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.font = [UIFont systemFontOfSize:22];
    _moneyLabel.textColor = [UIColor magentaColor];
    [self.contentView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    _guestLabel = [[UILabel alloc] init];
    _guestLabel.font = [UIFont systemFontOfSize:12];
    _guestLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _guestLabel.numberOfLines = 0;
    [self.contentView addSubview:_guestLabel];
    [_guestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(_moneyLabel.mas_right).offset(5);
        make.centerY.equalTo(self);
        make.width.equalTo(@180);
        make.height.equalTo(@50);
    }];
    
    
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _timeLabel.numberOfLines = 0;
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(_guestLabel.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(5);
        make.centerY.equalTo(self);
        make.width.equalTo(@80);
        make.height.equalTo(@50);
    }];
}








@end
