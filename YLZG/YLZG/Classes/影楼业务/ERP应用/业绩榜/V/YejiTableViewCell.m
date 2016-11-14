//
//  YejiTableViewCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "YejiTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "ImageBrowser.h"


@interface YejiTableViewCell ()

@property (strong,nonatomic) UIImageView *headV;

@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) UILabel *recordLabel;



@end

@implementation YejiTableViewCell

+ (instancetype)sharedYejiTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"YejiTableViewCell";
    YejiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[YejiTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setModel:(StaffYejiModel *)model
{
    _model = model;
    self.textLabel.text = [NSString stringWithFormat:@"%d",model.rank];
    self.textLabel.textColor = [UIColor grayColor];
    _nameLabel.text = model.staff;
    _recordLabel.text = model.record;
    if (model.rank <= 3) {
        // 前三名
        _recordLabel.textColor = RGBACOLOR(254, 196, 43, 1);
    }else{
        // 后三名
        _recordLabel.textColor = MainColor;
    }
    [_headV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
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
    self.headV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
    self.headV.layer.masksToBounds = YES;
    self.headV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.headV];
    [self.headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@40);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.headV.mas_right).offset(12);
        make.height.equalTo(@30);
    }];
    
    self.recordLabel = [[UILabel alloc]init];
    self.recordLabel.font = [UIFont systemFontOfSize:25];
    self.recordLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.recordLabel];
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@40);
    }];
    
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@2);
    }];
}
@end
