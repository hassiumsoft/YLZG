//
//  WorkSecretTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "WorkSecretTableCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>


@interface WorkSecretTableCell ()

/** 背景附带图 */
@property (strong,nonatomic) UIImageView *backImgView;
/** 标题 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 内容 */
@property (strong,nonatomic) UILabel *contentLabel;
/** 时间 */
@property (strong,nonatomic) UILabel *timeLabel;


@end

@implementation WorkSecretTableCell

+ (instancetype)sharedWorkCell:(UITableView *)tableView
{
    static NSString *ID = @"WorkSecretTableCell";
    WorkSecretTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WorkSecretTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = NorMalBackGroudColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setVersionModel:(VersionInfoModel *)versionModel
{
    _versionModel = versionModel;
    _titleLabel.text = versionModel.title;
    _contentLabel.text = versionModel.content;
    _timeLabel.text = versionModel.date;
    [_backImgView sd_setImageWithURL:[NSURL URLWithString:versionModel.imageurl] placeholderImage:[UIImage imageWithColor:HWRandomColor]];
}

- (void)setupSubViews
{
    // 时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top);
        make.height.equalTo(@24);
    }];
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(self.timeLabel.frame) + 24 + 8, SCREEN_WIDTH - 36, 160)];
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 5;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    
    // 背景图
    self.backImgView = [[UIImageView alloc]initWithFrame:bottomView.bounds];
    self.backImgView.layer.masksToBounds = YES;
    self.backImgView.layer.cornerRadius = 5;
    [bottomView addSubview:self.backImgView];
    
    // 标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, bottomView.width - 30, 25)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.backImgView addSubview:self.titleLabel];
    
    // 内容
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.numberOfLines = 4;
    self.contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [bottomView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    
    
    
}


@end
