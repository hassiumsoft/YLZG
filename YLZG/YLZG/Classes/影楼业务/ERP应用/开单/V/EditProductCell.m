//
//  EditProductCell.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/17.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "EditProductCell.h"
#import "UIView+Extension.h"
#import <Masonry.h>

@implementation EditProductCell

+ (instancetype)sharedEditProductCell:(UITableView *)tableView
{
    static NSString *ID = @"EditProductCell";
    EditProductCell *cell = [[EditProductCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    return cell;
}

- (void)setModel:(TaoxiProductModel *)model
{
    _model = model;
    _titleLabel.text = model.pro_name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@ x %@",model.pro_price,model.pro_num];
    
    if (model.isJiaji) {
        // 加急
        [self.jiajiImageV setHidden:NO];
        [self.jiajiLabel setHidden:NO];
        self.jiajiLabel.text = model.jiajiTime;
    }else{
        // 不加急
        [self.jiajiLabel setHidden:YES];
        [self.jiajiImageV setHidden:YES];
    }
    
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
- (void)setupSubViews
{
    UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(12, 0, 35, 75)];
    leftV.backgroundColor = RGBACOLOR(29, 163, 232, 1);
    leftV.userInteractionEnabled = YES;
    [self addSubview:leftV];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftV.frame), 0, SCREEN_WIDTH - 24 - 35 - 8, 75)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"我和动物朋友的影集";
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.titleLabel.textColor = RGBACOLOR(21, 21, 21, 1);
    [backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(17);
        make.left.equalTo(backView.mas_left).offset(20);
        make.height.equalTo(@21);
    }];
    
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.text = @"￥1850";
    self.priceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.priceLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    [backView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        make.left.equalTo(backView.mas_left).offset(20);
        make.height.equalTo(@20);
    }];
    
    self.jiajiLabel = [[UILabel alloc]init];
    self.jiajiLabel.text = @"2016年06月18日";
    self.jiajiLabel.textColor = [UIColor grayColor];
    self.jiajiLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    [backView addSubview:self.jiajiLabel];
    [self.jiajiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView.mas_bottom).offset(-2);
        make.right.equalTo(backView.mas_right).offset(-10);
        make.height.equalTo(@20);
    }];
    
    self.jiajiImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiaji"]];
    [backView addSubview:self.jiajiImageV];
    [self.jiajiImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-2);
        make.width.and.height.equalTo(@36);
        make.bottom.equalTo(self.jiajiLabel.mas_top);
    }];
    
    
}

#pragma mark - 代理告诉VC编辑产品
- (void)editProduct
{
    
    if (self.block) {
        self.block(self.model);
    }
}



- (UIImage *)imageWithBgColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


@end
