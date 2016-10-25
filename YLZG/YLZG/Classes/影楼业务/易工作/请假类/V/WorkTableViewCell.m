//
//  WorkTableViewCell.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/14.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "WorkTableViewCell.h"
#import <Masonry.h>

@implementation WorkTableViewCell

+ (instancetype)sharedWorkCell:(UITableView *)tableView
{
    static NSString *ID = @"WorkTableViewCell";
    WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[WorkTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    self.label = [[UILabel alloc]init];
    self.label.text = @"昵称";
    self.label.textColor = RGBACOLOR(10, 10, 10, 1);
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.equalTo(@(105));
        make.height.equalTo(@22);
    }];
    
    self.infoLabel = [[UILabel alloc]init];
    self.infoLabel.text = @"我在西樵山下";
    self.infoLabel.userInteractionEnabled = YES;
    self.infoLabel.textColor = RGBACOLOR(28, 28, 28, 1);
    self.infoLabel.font = [UIFont systemFontOfSize:13];
    self.infoLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-30);
        make.height.equalTo(@20);
    }];
    
    UIView *xian = [[UIView alloc]init];
    xian.backgroundColor = [UIColor lightGrayColor];
    [xian setAlpha:0.6];
    [self.contentView addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@0.5f);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
}

@end
