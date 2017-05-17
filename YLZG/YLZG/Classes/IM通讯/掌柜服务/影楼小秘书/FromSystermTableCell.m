//
//  FromSystermTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "FromSystermTableCell.h"
#import <Masonry.h>

@interface FromSystermTableCell ()

/** 来自系统的消息 */
@property (strong,nonatomic) UILabel *systermMsgLabel;
/** 时间 */
@property (strong,nonatomic) UILabel *timeLabel;
/** 气泡 */
@property (strong,nonatomic) UIImageView *paopaoImgView;

@end

@implementation FromSystermTableCell

+ (instancetype)sharedSystermCell:(UITableView *)tableView
{
    static NSString *ID = @"FromSystermTableCell";
    FromSystermTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FromSystermTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    
    CGSize textSize = [versionModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 51 - 80, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil].size;
    self.paopaoImgView.frame = CGRectMake(51 + 12, 33, textSize.width + 30, textSize.height + 30);
    
    _systermMsgLabel.text = versionModel.content;
    _timeLabel.text = versionModel.date;
    
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
    
    // 小秘书的头像
    UIImageView *headImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_minisec"]];
    headImgView.frame = CGRectMake(15, CGRectGetMaxY(self.timeLabel.frame) + 24 + 8, 40, 40);
    [self.contentView addSubview:headImgView];
    
    // 气泡
    self.paopaoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(headImgView.x + headImgView.width + 15, headImgView.y, SCREEN_WIDTH - headImgView.x - headImgView.width - 60, 40)];
    UIImage *image = [UIImage imageNamed:@"chat_receiver_bg"];
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *paoImage = [image resizableImageWithCapInsets:(UIEdgeInsets){0/scale,20/scale,5/scale,20/scale} resizingMode:UIImageResizingModeStretch];
    self.paopaoImgView.image = paoImage;
    [self.contentView addSubview:self.paopaoImgView];
    
    // 系统消息
    self.systermMsgLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.systermMsgLabel.textAlignment = NSTextAlignmentLeft;
    self.systermMsgLabel.numberOfLines = 0;
    self.systermMsgLabel.text = @"·······················";
    self.systermMsgLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.paopaoImgView addSubview:self.systermMsgLabel];
    
    [self.systermMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.paopaoImgView.mas_left).offset(12);
        make.right.equalTo(self.paopaoImgView.mas_right).offset(-5);
        make.centerY.equalTo(self.paopaoImgView.mas_centerY);
    }];
    
    
}

@end
