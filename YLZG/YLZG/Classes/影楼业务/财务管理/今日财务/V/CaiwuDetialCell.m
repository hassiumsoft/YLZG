//
//  CaiwuDetialCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "CaiwuDetialCell.h"
#import <Masonry.h>


@interface CaiwuDetialCell ()

/** 客户姓名 */
@property (strong,nonatomic) UILabel *customerLabel;
/** 开单人 */
@property (strong,nonatomic) UILabel *drawerLabel;
/** 收款金额 */
@property (strong,nonatomic) UILabel *moneyLabel;
/** 订单号 */
@property (strong,nonatomic) UILabel *orderLabel;
/** 收款人员 */
@property (strong,nonatomic) UILabel *payeeLabel;
/** 收款时间 */
@property (strong,nonatomic) UILabel *timeLabel;
/** 收款类型 */
//@property (strong,nonatomic) UILabel *typeLabel;


@end

@implementation CaiwuDetialCell

+ (instancetype)sharedCaiwuDetialCell:(UITableView *)tableView
{
    static NSString *ID = @"CaiwuDetialCell";
    CaiwuDetialCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CaiwuDetialCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
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
    // 客人姓名
    self.customerLabel = [[UILabel alloc]init];
    self.customerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.customerLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.customerLabel];
    [self.customerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(6);
        make.height.equalTo(@21);
    }];
    
    // 价格
    self.moneyLabel = [[UILabel alloc]init];
    self.moneyLabel.textColor = WechatRedColor;
    self.moneyLabel.font = [UIFont boldSystemFontOfSize:22];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customerLabel.mas_bottom).offset(5);
        make.height.equalTo(@25);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    
    //  开单人
    UILabel *drawerL = [[UILabel alloc]init];
    drawerL.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    drawerL.textColor = RGBACOLOR(57, 37, 37, 1);
    drawerL.text = @"开单人";
    [self addSubview:drawerL];
    [drawerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@21);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(15);
    }];
    
    self.drawerLabel = [[UILabel alloc]init];
    self.drawerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.drawerLabel.textAlignment = NSTextAlignmentRight;
    self.drawerLabel.textColor = RGBACOLOR(37, 37, 37, 1);
    [self addSubview:self.drawerLabel];
    [self.drawerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@21);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(15);
    }];
    
    // 收款人
    
    UILabel *payeeL = [[UILabel alloc]init];
    payeeL.text = @"收款人";
    payeeL.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    payeeL.textColor = RGBACOLOR(57, 37, 37, 1);
    [self addSubview:payeeL];
    [payeeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@21);
        make.top.equalTo(self.drawerLabel.mas_bottom);
    }];
    
    self.payeeLabel = [[UILabel alloc]init];
    self.payeeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.drawerLabel.textAlignment = NSTextAlignmentRight;
    self.payeeLabel.textColor = RGBACOLOR(57, 57, 57, 1);
    [self addSubview:self.payeeLabel];
    [self.payeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@21);
        make.top.equalTo(self.drawerLabel.mas_bottom);
    }];
    
    
    // 创建时间
    UILabel *timeL = [[UILabel alloc]init];
    timeL.text = @"创建时间";
    timeL.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    timeL.textColor = RGBACOLOR(57, 37, 37, 1);
    [self addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@21);
        make.top.equalTo(payeeL.mas_bottom);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = RGBACOLOR(57, 57, 57, 1);
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@21);
        make.top.equalTo(self.payeeLabel.mas_bottom);
    }];
}
- (void)setModel:(CaiwuDetialModel *)model
{
    _model = model;
    _customerLabel.text = model.customer;
    _drawerLabel.text = model.drawer;
    _moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.money];
    _orderLabel.text = model.order;
    _payeeLabel.text = model.payee;
    _timeLabel.text = model.time;
//    _typeLabel.text = model.type;
}

@end
