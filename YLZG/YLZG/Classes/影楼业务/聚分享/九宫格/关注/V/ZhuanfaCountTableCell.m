//
//  ZhuanfaCountTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ZhuanfaCountTableCell.h"
#import "YLZGDataManager.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>



@interface ZhuanfaCountTableCell ()

@property (strong,nonatomic) UIImageView *headV;

@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) UILabel *timeLabel;

@property (strong,nonatomic) UILabel *countLabel;


@end

@implementation ZhuanfaCountTableCell

+ (instancetype)sharedZhuanfaCountCell:(UITableView *)tableView
{
    static NSString *ID = @"ZhuanfaCountTableCell";
    ZhuanfaCountTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZhuanfaCountTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (void)setModel:(ZhuanfaListModel *)model
{
    _model = model;
    [[YLZGDataManager sharedManager] getOneStudioByUID:model.uid Block:^(ContactersModel *model) {
        [_headV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
        _nameLabel.text = model.realname;
    }];
    
    _timeLabel.text = [self timeIntervalToDate:model.create_at];
    _countLabel.text = model.times;
    
    
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

- (void)setupSubViews
{
    self.headV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    self.headV.contentMode = UIViewContentModeScaleAspectFill;
    self.headV.layer.masksToBounds = YES;
    self.headV.layer.cornerRadius = 4;
    [self.contentView addSubview:self.headV];
    [self.headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@40);
    }];
    
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headV.mas_right).offset(6);
        make.bottom.equalTo(self.mas_centerY);
        make.height.equalTo(@21);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = RGBACOLOR(56, 56, 56, 1);;
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.mas_centerY);
        make.height.equalTo(@21);
    }];
    
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 15, 60, 30)];
    self.countLabel.textColor = MainColor;
    self.countLabel.font = [UIFont boldSystemFontOfSize:24];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.countLabel];
}

@end
