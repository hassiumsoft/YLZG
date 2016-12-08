//
//  ToolsTableViewCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/11.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ToolsTableViewCell.h"
#import <Masonry.h>

@interface ToolsTableViewCell ()

@property (strong,nonatomic) UIImageView *appIconV;

@property (strong,nonatomic) UILabel *appNameLabel;

@property (strong,nonatomic) UILabel *detialLabel;

@end


@implementation ToolsTableViewCell

+ (instancetype)sharedToolsCell:(UITableView *)tableView
{
    static NSString *ID = @"ToolsTableViewCell";
    ToolsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[ToolsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(ToolsModel *)model
{
    _model = model;
    self.appIconV.image = [UIImage imageNamed:model.appImageName];
    self.appNameLabel.text = model.appName;
    self.appNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.detialLabel.text = model.appDetial;
    self.detialLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
}

- (void)setupSubViews
{
    UIImageView *topXian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self addSubview:topXian];
    [topXian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@2);
    }];
    
    self.appIconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"12"]];
    [self addSubview:self.appIconV];
    [self.appIconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(3);
        make.width.and.height.equalTo(@(40));
    }];
    
    self.appNameLabel = [[UILabel alloc]init];
    self.appNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.appNameLabel];
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.appIconV.mas_centerY);
        make.left.equalTo(self.appIconV.mas_right).offset(6);
        make.height.equalTo(@22);
    }];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.layer.borderColor = MainColor.CGColor;
    button.layer.borderWidth = 1.f;
    [button setTitle:@"详 情" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button addTarget:self action:@selector(openApp) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:MainColor forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(@35);
        make.width.equalTo(@48);
    }];
    
    self.detialLabel = [[UILabel alloc]init];
    self.detialLabel.textColor = [UIColor grayColor];
    self.detialLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.detialLabel.numberOfLines = 2;
    [self addSubview:self.detialLabel];
    [self.detialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appNameLabel.mas_bottom);
        make.left.equalTo(self.appNameLabel.mas_left);
        make.right.equalTo(button.mas_left);
        make.height.equalTo(@44);
    }];
    
}

- (void)openApp
{
    if (self.DidSelectBlock) {
        _DidSelectBlock();
    }
}

@end
