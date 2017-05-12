//
//  HistoryMessageTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/12.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "HistoryMessageTableCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface HistoryMessageTableCell ()

/** 头像 */
@property (strong,nonatomic) UIImageView *headImageV;
/** 名字 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 最后一条消息 */
@property (strong,nonatomic) UILabel *lastMsgLabel;
/** 时间 */
@property (strong,nonatomic) UILabel *timeLabel;

@end

@implementation HistoryMessageTableCell

+ (instancetype)sharedHistoryCell:(UITableView *)tableView
{
    static NSString *ID = @"HistoryMessageTableCell";
    HistoryMessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HistoryMessageTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setContactModel:(ContactersModel *)contactModel
{
    _contactModel = contactModel;
    _nameLabel.text = contactModel.nickname.length >= 1 ? contactModel.nickname : contactModel.realname;
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:contactModel.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
}

- (void)setLastMessage:(NSString *)lastMessage
{
    _lastMessage = lastMessage;
    _lastMsgLabel.text = lastMessage;
}
- (void)setTime:(NSString *)time
{
    _time = time;
    _timeLabel.text = time;
}

- (void)setupSubViews
{
    // 头像
    self.headImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"group_back"]];
    self.headImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageV.layer.masksToBounds = YES;
    self.headImageV.layer.cornerRadius = 4;
    [self addSubview:self.headImageV];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(5);
        make.width.and.height.equalTo(@50);
    }];
    
    // 时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-13);
        make.height.equalTo(@21);
        make.bottom.equalTo(self.headImageV.mas_centerY).offset(-3);
    }];
    
    // 昵称
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"未知消息";
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(78);
        make.right.equalTo(self.timeLabel.mas_left).offset(-5);
        make.height.equalTo(@21);
        make.bottom.equalTo(self.headImageV.mas_centerY);
    }];
    
    // 最后一条消息
    self.lastMsgLabel = [[UILabel alloc]init];
    self.lastMsgLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.lastMsgLabel.numberOfLines = 0;
    self.lastMsgLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    [self addSubview:self.lastMsgLabel];
    [self.lastMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-20);
    }];

}





@end
