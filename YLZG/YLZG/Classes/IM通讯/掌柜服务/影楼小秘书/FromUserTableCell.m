//
//  FromUserTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/17.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "FromUserTableCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "UserInfoManager.h"

@interface FromUserTableCell ()

@property (strong,nonatomic) UIImageView *headImgView;

@property (strong,nonatomic) UILabel *messageLabel;

@property (strong,nonatomic) UILabel *timeLabel;

/** 气泡 */
@property (strong,nonatomic) UIImageView *paopaoImgView;

@end


@implementation FromUserTableCell

+ (instancetype)sharedUserCell:(UITableView *)tableView
{
    static NSString *ID = @"FromUserTableCell";
    FromUserTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FromUserTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    _timeLabel.text = versionModel.date;
    
    CGSize textSize = [versionModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 51 - 80, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil].size;
    self.paopaoImgView.frame = CGRectMake(SCREEN_WIDTH - 40 - 15 - 12 - textSize.width - 23, 38, textSize.width + 30, textSize.height + 30);
    _messageLabel.text = versionModel.content;
    
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
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.height.equalTo(@24);
    }];
    
    self.headImgView = [[UIImageView alloc]init];
    UserInfoModel *userModel = [[UserInfoManager sharedManager] getUserInfo];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:userModel.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    [self.contentView addSubview:self.headImgView];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.width.and.height.equalTo(@40);
    }];
    
    // 气泡
    self.paopaoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 40, SCREEN_WIDTH - 60 - 40 - 15 - 15, 40)];
    UIImage *image = [UIImage imageNamed:@"chat_sender_bg"];
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *paoImage = [image resizableImageWithCapInsets:(UIEdgeInsets){0/scale,20/scale,5/scale,20/scale} resizingMode:UIImageResizingModeStretch];
    self.paopaoImgView.image = paoImage;
    [self.contentView addSubview:self.paopaoImgView];
    
    // 我发送的消息
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.messageLabel.textAlignment = NSTextAlignmentRight;
    self.messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.messageLabel.numberOfLines = 0;
    [self.paopaoImgView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.paopaoImgView.mas_left).offset(12);
        make.right.equalTo(self.paopaoImgView.mas_right).offset(-15);
        make.centerY.equalTo(self.paopaoImgView.mas_centerY);
    }];
    
}
@end
