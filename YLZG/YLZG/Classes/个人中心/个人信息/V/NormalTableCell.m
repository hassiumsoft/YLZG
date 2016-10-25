//
//  NormalTableCell.m
//  佛友圈
//
//  Created by Chan_Sir on 16/1/16.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NormalTableCell.h"
#import <Masonry.h>

@implementation NormalTableCell

+ (instancetype)sharedNormalTableCell:(UITableView *)tableView
{
    static NSString *ID = @"NormalCell";
    NormalTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[NormalTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hero_pulse"]];
    [self addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.and.height.equalTo(@26);
    }];
    
    self.label = [[UILabel alloc]init];
    self.label.font = [UIFont systemFontOfSize:16];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@21);
        make.left.equalTo(self.imageV.mas_right).offset(10);
    }];
    
    self.xian = [[UIView alloc]init];
    _xian.backgroundColor = NorMalBackGroudColor;
    [self addSubview:_xian];
    [_xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
}

@end
