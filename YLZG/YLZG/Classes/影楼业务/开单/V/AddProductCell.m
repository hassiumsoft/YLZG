//
//  AddProductCell.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/18.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "AddProductCell.h"
#import <Masonry.h>

@implementation AddProductCell

+ (instancetype)sharedAddProductCell:(UITableView *)tableView
{
    static NSString *ID = @"AddProductCell";
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    AddProductCell *cell = [[AddProductCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = NorMalBackGroudColor;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}
- (void)setModel:(AllProductList *)model
{
    _model = model;
    _titleLabel.text = model.pro_name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",model.pro_price];
}
- (void)setupSubViews
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH*0.66 - 16, 90 - 8)];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"product_add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addProduct:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(backView.mas_right);
        make.height.equalTo(@40);
        make.width.equalTo(@55);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.titleLabel.textColor = RGBACOLOR(20, 20, 20, 1);
    [backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(addButton.mas_left);
        make.top.equalTo(backView.mas_top).offset(20);
    }];
    
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.text = @"￥3999";
    self.priceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.priceLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    [backView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1);
        make.height.equalTo(@21);
        make.left.equalTo(self.titleLabel.mas_left);
    }];
}

- (void)addProduct:(UIButton *)sender
{
    [sender removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(addProduct:)]) {
        [self.delegate addProduct:self.model];
    }
}

@end
