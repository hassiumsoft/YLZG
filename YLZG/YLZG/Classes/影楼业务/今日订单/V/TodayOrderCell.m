//
//  TodayOrderCell.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/27.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "TodayOrderCell.h"
#import <Masonry.h>

@interface TodayOrderCell ()

// 白色底部
@property (nonatomic, strong) UIView * whiteView;
// 图片
@property (nonatomic, strong) UIImageView * iconImage;

@end

@implementation TodayOrderCell

+ (instancetype)sharedTodayOrderCell:(UITableView *)tableView
{
    static NSString *ID = @"TodayOrderCell";
    TodayOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[TodayOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setModel:(TodayOrderModel *)model
{
    _model = model;
    _orderLabel.text = [NSString stringWithFormat:@"订单号：%@",model.id];
    _storeLabel.text = model.store;
    _guestLabel.text = model.guest;
    _setLabel.text = model.set;
    NSString *priceStr = [NSString stringWithFormat:@"¥%@", model.price];
    _priceLabel.text = priceStr;
    _dateLabel.text = model.date;
    
    if (model.price.length >= 1) {
        // 富文本
        NSMutableAttributedString * graytext = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [graytext beginEditing];
        
        [graytext addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:WechatRedColor} range:NSMakeRange(1, model.price.length)];
        
        _priceLabel.attributedText =  graytext;
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
        
    }
    return self;
}

- (void)setupSubViews
{
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 145)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_whiteView];
    // 订单号
    self.orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 16)];
    self.orderLabel.font = [UIFont systemFontOfSize:15];
    self.orderLabel.textColor = RGBACOLOR(74, 74, 74, 1);
    [_whiteView addSubview:self.orderLabel];
    
    // 门市(开单员工)
    self.storeLabel = [[UILabel alloc] init];
    self.storeLabel.font = [UIFont systemFontOfSize:15];
    self.storeLabel.numberOfLines = 2;
    self.storeLabel.textAlignment = NSTextAlignmentRight;
    self.storeLabel.textColor = MainColor;
    [_whiteView addSubview:self.storeLabel];
    [self.storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.whiteView.mas_right).offset(-15);
        make.height.equalTo(@42);
        make.centerY.equalTo(self.orderLabel.mas_centerY);
    }];
    
    // 画线
    [self grayLineFrame:CGRectMake(10, CGRectGetMaxY(self.orderLabel.frame)+10, SCREEN_WIDTH-20, 0.5)];
    
    // 图片
    UIImage * image = [UIImage imageNamed:@"Today_OrderImg"];
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.orderLabel.frame), CGRectGetMaxY(_orderLabel.frame)+20, image.size.width, image.size.height)];
    self.iconImage.image = image;
    [_whiteView addSubview:self.iconImage];
    
    // 客户
    self.guestLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.guestLabel.font = [UIFont systemFontOfSize:15];
    self.guestLabel.textAlignment = NSTextAlignmentRight;
    self.guestLabel.textColor = RGBACOLOR(74, 74, 74, 1);
    [_whiteView addSubview:self.guestLabel];
    [self.guestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_top);
        make.left.equalTo(self.iconImage.mas_right).offset(8);
        make.height.equalTo(@21);
    }];

    // 套系
    self.setLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.setLabel.font = [UIFont systemFontOfSize:13];
    self.setLabel.textColor = RGBACOLOR(106, 106, 106, 1);
    [_whiteView addSubview:self.setLabel];
    [self.setLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.guestLabel.mas_left);
        make.top.equalTo(self.guestLabel.mas_bottom).offset(-2);
        make.height.equalTo(@21);
    }];
    
    // 价格
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel.font = [UIFont systemFontOfSize:15];
    self.priceLabel.textColor = RGBACOLOR(74, 74, 74, 1);
    [_whiteView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.whiteView.mas_right).offset(-15);
        make.height.equalTo(@21);
        make.bottom.equalTo(self.whiteView.mas_bottom).offset(-2);
    }];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self.whiteView addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.whiteView.mas_bottom).offset(-30);
        make.height.equalTo(@2);
        make.left.equalTo(self.whiteView.mas_left);
        make.right.equalTo(self.whiteView.mas_right);
    }];
    
    
    
    // 时间
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_storeLabel.frame), CGRectGetMaxY(_whiteView.frame)-25, 85, 16)];
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    self.dateLabel.textColor = RGBACOLOR(196, 196, 196, 1);
    [_whiteView addSubview:self.dateLabel];
    
    
    
    self.callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.callBtn setImage:[UIImage imageNamed:@"phoneLabel"] forState:UIControlStateNormal];
    [self.callBtn setImage:[UIImage imageNamed:@"phoneLabel_highted"] forState:UIControlStateHighlighted];
    [self.callBtn addTarget:self action:@selector(callCusPhone:) forControlEvents:UIControlEventTouchUpInside];
    [self.callBtn setFrame:CGRectMake(SCREEN_WIDTH - 60, 65, 38, 38)];
    [self addSubview:self.callBtn];
    
}

#pragma mark -中间两条横线的封装
- (UIView *)grayLineFrame:(CGRect)frame {
    UIView * grayView = [[UIView alloc] initWithFrame:frame];
    grayView.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    [self.whiteView addSubview:grayView];
    return grayView;
}

- (void)callCusPhone:(UIButton *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(openPhoneWebView:)]) {
        [self.delegate openPhoneWebView:self.model];
    }
    
}

@end
