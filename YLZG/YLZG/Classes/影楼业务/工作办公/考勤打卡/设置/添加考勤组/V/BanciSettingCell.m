//
//  BanciSettingCell.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "BanciSettingCell.h"
#import <Masonry.h>

@implementation BanciSettingCell

+ (instancetype)sharedBanciSettingCell:(UITableView *)tableView
{
    static NSString *ID = @"BanciSettingCell";
    BanciSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BanciSettingCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessoryType:UITableViewCellAccessoryDetailButton];
        [self setupSubviews];
    }
    return self;
}
- (void)setModel:(BanciModel *)model
{
    _model = model;
    _nameLabel.text = model.classname;
    _timeLabl.text = [NSString stringWithFormat:@"%@-%@",model.start,model.end];
    if (model.isSelected) {
        [self.selectedBtn setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
    }else{
        [self.selectedBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    }
    
}
- (void)setupSubviews
{
    // 是否选中的按钮
    self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.selectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.selectedBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    [self addSubview:self.selectedBtn];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.and.height.equalTo(@35);
    }];
    
    // 班次名称
    self.nameLabel = [UILabel new];
    self.nameLabel.text = @"班次AA";
    self.nameLabel.textColor = RGBACOLOR(10, 10, 10, 1);
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@23);
        make.left.equalTo(self.selectedBtn.mas_right).offset(8);
    }];
    
    // 班次时间
    self.timeLabl = [UILabel new];
    self.timeLabl.text = @"09:00-18:00";
    self.timeLabl.textColor = RGBACOLOR(40, 40, 40, 1);
    self.timeLabl.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.timeLabl];
    [self.timeLabl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@23);
        make.left.equalTo(self.nameLabel.mas_right).offset(12);
    }];
    
//    // 编辑按钮
//    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [editBtn setImage:[UIImage imageNamed:@"edit_img"] forState:UIControlStateNormal];
//    [editBtn addTarget:self action:@selector(editBanci) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:editBtn];
//    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mas_centerY);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.width.and.height.equalTo(@28);
//    }];
    
}
- (void)editBanci
{
    if ([self.delegate respondsToSelector:@selector(banciSetPushAction:)]) {
        [self.delegate banciSetPushAction:self.model];
    }
}


@end
