//
//  EditProductCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/1.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "EditProductCell.h"
#import <Masonry.h>

@interface EditProductCell ()<UITextFieldDelegate>

/** 产品名称 */
@property (strong,nonatomic) UILabel *productPrice;
/** 产品单价 */
@property (strong,nonatomic) UILabel *productName;
/** 产品数量 */
@property (strong,nonatomic) UITextField *productNumField;
/** 加急图标 */
@property (strong,nonatomic) UIImageView *jiajiImage;
/** 加急时间 */
@property (copy,nonatomic) UILabel *jiajiTimeL;

@end

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
    _productName.text = model.pro_name;
    _productPrice.text = [NSString stringWithFormat:@"￥%@",model.pro_price];
    _jiajiTimeL.text = model.urgentTime;
    if ([model.isUrgent intValue] == 1) {
        self.jiajiTimeL.hidden = NO;
        self.jiajiImage.hidden = NO;
    }else{
        self.jiajiTimeL.hidden = YES;
        self.jiajiImage.hidden = YES;
    }
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = NorMalBackGroudColor;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubView];
    }
    return self;
}
- (void)setupSubView
{
    // 产品名称
    self.productName = [[UILabel alloc]initWithFrame:CGRectMake(18, 10, 150, 21)];
    self.productName.font = [UIFont systemFontOfSize:14];
    self.productName.textColor = RGBACOLOR(87, 87, 87, 1);
    [self addSubview:self.productName];
    
    
    // 产品数量
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(self.productName.frame), 40, 23)];
    numLabel.text = @"产品数量:";
    numLabel.layer.masksToBounds = YES;
    numLabel.layer.cornerRadius = 4;
    numLabel.font = [UIFont systemFontOfSize:12];
    numLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    [self addSubview:numLabel];
    
    self.productNumField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame)+2, CGRectGetMaxY(self.productName.frame), 40, 21)];
    self.productNumField.text = @"1";
    self.productNumField.delegate = self;
    self.productNumField.backgroundColor = [UIColor whiteColor];
    self.productNumField.font = [UIFont systemFontOfSize:12];
    self.productNumField.keyboardType = UIKeyboardTypeNumberPad;
    self.productNumField.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.productNumField];
    
    
    // 产品价格
    self.productPrice = [[UILabel alloc]init];
    self.productPrice.textAlignment = NSTextAlignmentRight;
    self.productPrice.font = self.productName.font;
    self.productPrice.textColor = self.productName.textColor;
    [self addSubview:self.productPrice];
    [self.productPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@21);
    }];
    
    // 加急时间
    [self addSubview:self.jiajiTimeL];
    [self.jiajiTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-120);
        make.width.equalTo(@120);
        make.height.equalTo(@21);
    }];
    
    // 加急图标 jiaji_icon
    [self addSubview:self.jiajiImage];
    [self.jiajiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.jiajiTimeL.mas_centerX);
        make.width.and.height.equalTo(@40);
    }];
    
    self.jiajiImage.hidden = YES;
    self.jiajiTimeL.hidden = YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""] || [textField.text isEqualToString:@"0"]) {
        _productNumField.text = @"1";
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isChinese]) {
        return NO;
    }else{
        return YES;
    }
}
- (UIImageView *)jiajiImage
{
    if (!_jiajiImage) {
        _jiajiImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiaji"]];
    }
    return _jiajiImage;
}
- (UILabel *)jiajiTimeL
{
    if (!_jiajiTimeL) {
        _jiajiTimeL = [[UILabel alloc]init];
        _jiajiTimeL.font = [UIFont systemFontOfSize:12];
        _jiajiTimeL.textColor = [UIColor grayColor];
        _jiajiTimeL.textAlignment = NSTextAlignmentCenter;
    }
    return _jiajiTimeL;
}

@end
