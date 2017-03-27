//
//  CardNumTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CardNumTableCell.h"
#import <Masonry.h>
#import "UserInfoManager.h"


@interface CardNumTableCell ()

/** 会员名字 */
@property (strong,nonatomic) UILabel *customerLabel;
/** 余额 */
@property (strong,nonatomic) UILabel *balanceLabel;
/** 积分 */
@property (strong,nonatomic) UILabel *creditLabel;
/** 会员卡号 */
@property (strong,nonatomic) UILabel *numberLabel;
/** 电话 */
@property (strong,nonatomic) UILabel *phoneLabel;
/** 卡片类型 */
@property (strong,nonatomic) UILabel *typeLabel;

/** 卡片类型图片 */
@property (strong,nonatomic) UIImageView *imageV;


@end

@implementation CardNumTableCell

+ (instancetype)sharedCardNumTableCell:(UITableView *)tableView
{
    static NSString *ID = @"CardNumTableCell";
    CardNumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[CardNumTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}


- (void)setModel:(OpenOrderCardModel *)model
{
    _model = model;
    _customerLabel.text = model.customer;
    _numberLabel.text = [NSString stringWithFormat:@"卡号：%@",model.number];
    _typeLabel.text = model.type;
    if ([model.type containsString:@"金卡"]) {
        _imageV.image = [UIImage imageNamed:@"card_gold"];
    } else if([model.type containsString:@"现金"]){
        _imageV.image = [UIImage imageNamed:@"card_xianjin"];
    }else if ([model.type containsString:@"钻"]){
        _imageV.image = [UIImage imageNamed:@"card_zhuan"];
    }else{
        _imageV.image = [UIImage imageNamed:@"card_normal"];
    }
    if ([[[UserInfoManager sharedManager] getUserInfo].type intValue] == 1) {
        _phoneLabel.text = [NSString stringWithFormat:@"📱 %@",model.phone];
    }else{
        NSString *phone = model.phone;
        if (phone.length >= 11) {
            NSString *lastNum = [phone substringWithRange:NSMakeRange(phone.length - 4, 4)];
            phone = [phone stringByReplacingOccurrencesOfString:lastNum withString:@"****"];
        }
        _phoneLabel.text = [NSString stringWithFormat:@"📱 %@",phone];
    }
    _creditLabel.text = [NSString stringWithFormat:@"积分：%@",model.credit];
    _balanceLabel.text = [NSString stringWithFormat:@"￥%@",model.balance];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 120 - 6, SCREEN_WIDTH, 6)];
    bottomV.backgroundColor = NorMalBackGroudColor;
    [self addSubview:bottomV];
    
    // 客户名字
    self.customerLabel = [[UILabel alloc]init];
    self.customerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.customerLabel];
    [self.customerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@21);
    }];
    
    // 客户卡号
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.numberLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    [self addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customerLabel.mas_left);
        make.top.equalTo(self.customerLabel.mas_bottom);
        make.height.equalTo(@21);
    }];
    
    // 卡片类型
    
    self.imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"card_normal"]];
    self.imageV.contentMode = UIStackViewDistributionFill;
    [self addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(self.mas_top).offset(-5);
        make.width.equalTo(@86);
        make.height.equalTo(@80);
    }];
    
    self.typeLabel = [UILabel new];
    self.typeLabel.font = [UIFont systemFontOfSize:11];
    self.typeLabel.textAlignment = NSTextAlignmentRight;
    self.typeLabel.textColor = [UIColor whiteColor];
    [self.imageV addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageV.mas_right).offset(-7);
        make.bottom.equalTo(self.imageV.mas_bottom).offset(-20);
        make.height.equalTo(@20);
    }];
    
    
    
    // 电话号码
    self.phoneLabel = [UILabel new];
    self.phoneLabel.font = [UIFont systemFontOfSize:15];
    self.phoneLabel.textColor = RGBACOLOR(57, 57, 57, 1);
    [self addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customerLabel.mas_left);
        make.bottom.equalTo(bottomV.mas_top);
        make.height.equalTo(@30);
    }];
    
    UIImageView *xianV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self addSubview:xianV];
    [xianV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@2);
        make.bottom.equalTo(self.phoneLabel.mas_top);
    }];
    
    // 余额
    self.balanceLabel = [[UILabel alloc]init];
    self.balanceLabel.textColor = WechatRedColor;
    self.balanceLabel.textAlignment = NSTextAlignmentCenter;
    self.balanceLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:self.balanceLabel];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(SCREEN_WIDTH * 0.8));
        make.height.equalTo(@35);
    }];
    // 积分
    self.creditLabel = [UILabel new];
    self.creditLabel.textAlignment = NSTextAlignmentRight;
    self.creditLabel.font = [UIFont systemFontOfSize:15];
    self.creditLabel.textColor = WechatRedColor;
    [self addSubview:self.creditLabel];
    [self.creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.phoneLabel.mas_centerY);
    }];
    
}

@end
