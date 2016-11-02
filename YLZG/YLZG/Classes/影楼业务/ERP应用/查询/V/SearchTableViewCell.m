//
//  SearchTableViewCell.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SearchTableViewCell.h"
#import <Masonry.h>



@implementation SearchTableViewCell

+ (instancetype)sharedSearchTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"SearchTableViewCell";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[SearchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self createCell];
    }
    return self;
}

- (void)setModel:(SearchViewModel *)model {
    _model = model;
    _orderIDLabel.text = [NSString stringWithFormat:@"订单号：%@",model.tradeID];
    _setLabel.text = model.set;
    _storeLabel.text = [NSString stringWithFormat:@"开单人：%@",model.store];
    _guestnameLabel.text = model.guestname;
    _phoneLabel.text = model.phone;
    _proceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:_proceLabel.text];
    [attriStr beginEditing];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] range:NSMakeRange(0, 1)];
    [attriStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(235, 79, 65, 1) range:NSMakeRange(1, model.price.length)];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(1, model.price.length)];
    _proceLabel.attributedText = attriStr;
    
    
}

- (void)createCell {
    // 订单号
    self.orderIDLabel = [[UILabel alloc]init];
    self.orderIDLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.orderIDLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.orderIDLabel];
    [self.orderIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(4);
        make.height.equalTo(@21);
    }];
    // 虚线
    UIImageView *xian1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self addSubview:xian1];
    [xian1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderIDLabel.mas_bottom).offset(4);
        make.height.equalTo(@2);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right);
    }];
    // 修饰图片
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Today_OrderImg"]];
    imageV.layer.masksToBounds = YES;
    imageV.layer.cornerRadius = 4;
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xian1.mas_bottom).offset(4);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.and.height.equalTo(@40);
    }];
    // 客人名字
    self.guestnameLabel = [[UILabel alloc]init];
    self.guestnameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.guestnameLabel.textColor = RGBACOLOR(18, 18, 18, 1);
    [self addSubview:self.guestnameLabel];
    [self.guestnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(5);
        make.top.equalTo(xian1.mas_top).offset(5);
        make.height.equalTo(@21);
    }];
    // 套系名称
    self.setLabel = [[UILabel alloc]init];
    self.setLabel.font = [UIFont systemFontOfSize:13];
    self.setLabel.textColor = [UIColor grayColor];
    [self addSubview:self.setLabel];
    [self.setLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(5);
        make.top.equalTo(self.guestnameLabel.mas_bottom);
        make.height.equalTo(@21);
    }];
    
    // 虚线
    UIImageView *xian2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self addSubview:xian2];
    [xian2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(15);
        make.height.equalTo(@2);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right);
    }];
    UIView *kkk = [[UIView alloc]init];
    kkk.backgroundColor = [UIColor whiteColor];
    [self addSubview:kkk];
    [kkk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xian2.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    // 价格
    self.proceLabel = [UILabel new];
    self.proceLabel.textColor = [UIColor grayColor];
    [kkk addSubview:self.proceLabel];
    [self.proceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(kkk.mas_centerY);
        make.right.equalTo(kkk.mas_right).offset(-12);
        make.top.equalTo(kkk.mas_top);
        
    }];
    
    // 负责人
    self.storeLabel = [UILabel new];
    self.storeLabel.textColor = [UIColor grayColor];
    self.storeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    [kkk addSubview:self.storeLabel];
    [self.storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(kkk.mas_centerY);
        make.left.equalTo(kkk.mas_left).offset(15);
        make.top.equalTo(kkk.mas_top);
        
    }];
    
}


@end
