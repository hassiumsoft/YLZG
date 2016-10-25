//
//  OfflineOrderTableCell.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/24.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "OfflineOrderTableCell.h"
#import <Masonry.h>

@implementation OfflineOrderTableCell

+ (instancetype)sharedOfflineOrderCell:(UITableView *)tableView
{
    static NSString *ID = @"OfflineOrderTableCell";
    OfflineOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[OfflineOrderTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (void)setModel:(OffLineOrder *)model
{
    _model = model;
    _cusNameLabel.text = model.guest;
    _cusPhoneLabel.text = model.mobile;
    _beizhuLabel.text = model.msg;
    _timeLabel.text = model.saveTime;
    _taoxiLabel.text = model.set;
    
    NSString *price = model.price;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",price];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:_priceLabel.text];
    [attriStr beginEditing];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] range:NSMakeRange(0, 1)];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(1, price.length)];
    [attriStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(232, 68, 68, 1) range:NSMakeRange(1, price.length)];
    _priceLabel.attributedText = attriStr;
    
    if (model.isSelectedSend) {
        // 选中
        [self.selectedBtn setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
    }else{
        // 没选中
        [self.selectedBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    }
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal]; // EditControlSelected
    [self.selectedBtn addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectedBtn];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(5);
        make.width.and.height.equalTo(@40);
    }];
    
    self.cusNameLabel = [[UILabel alloc]init];
    self.cusNameLabel.textColor = [UIColor blackColor];
    self.cusNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.cusNameLabel];
    [self.cusNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedBtn.mas_right);
        make.top.equalTo(self.mas_top).offset(6);
        make.height.equalTo(@30);
    }];
    
    self.cusPhoneLabel = [[UILabel alloc]init];
    self.cusPhoneLabel.textColor = [UIColor grayColor];
    self.cusPhoneLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    [self addSubview:self.cusPhoneLabel];
    [self.cusPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cusNameLabel.mas_bottom);
        make.height.equalTo(@21);
        make.left.equalTo(self.cusNameLabel.mas_left);
    }];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cusNameLabel.mas_left);
        make.top.equalTo(self.cusPhoneLabel.mas_bottom).offset(6);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@2);
    }];
    
    UIView *bottomV = [[UIView alloc]init];
    bottomV.backgroundColor = self.backgroundColor;
    [self addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(xian.mas_left);
        make.right.equalTo(xian.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(xian.mas_bottom);
    }];
    
    self.beizhuLabel = [[UILabel alloc]init];
    self.beizhuLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.beizhuLabel.textColor = [UIColor lightGrayColor];
    self.beizhuLabel.numberOfLines = 2;
//    self.beizhuLabel.backgroundColor = HWRandomColor;
    [bottomV addSubview:self.beizhuLabel];
    [self.beizhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomV.mas_left);
        make.right.equalTo(bottomV.mas_right).offset(-120);
        make.centerY.equalTo(bottomV.mas_centerY);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomV.mas_centerY);
        make.right.equalTo(bottomV.mas_right).offset(-10);
    }];
    
    self.taoxiLabel = [[UILabel alloc]init];
    self.taoxiLabel.textColor = RGBACOLOR(38, 38, 38, 1);
    self.taoxiLabel.font = [UIFont systemFontOfSize:15];
    self.taoxiLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.taoxiLabel];
    [self.taoxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@22);
        make.top.equalTo(self.mas_top).offset(12);
    }];
    
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.textColor = [UIColor grayColor];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@30);
        make.top.equalTo(self.taoxiLabel.mas_bottom);
    }];
    
}
- (void)selectedClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(offLineOrderCell:)]) {
        [self.delegate offLineOrderCell:self];
    }
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 选中
        [sender setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
        _model.isSelectedSend = YES;
    }else{
        // 没选中
        [sender setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
        _model.isSelectedSend = NO;
    }
}

@end
