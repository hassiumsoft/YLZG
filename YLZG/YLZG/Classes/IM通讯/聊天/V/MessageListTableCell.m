//
//  MessageListTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/13.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MessageListTableCell.h"
#import <Masonry.h>
#import "YLZGDataManager.h"
#import "GroupListManager.h"
#import <UIImageView+WebCache.h>
#import "EaseConvertToCommonEmoticonsHelper.h"


@interface MessageListTableCell ()
/** 头像 */
@property (strong,nonatomic) UIImageView *headImageV;
/** 名字 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 最后一条消息 */
@property (strong,nonatomic) UILabel *lastMsgLabel;
/** 时间 */
@property (strong,nonatomic) UILabel *timeLabel;
/** 未读消息数 */
@property (strong,nonatomic) UILabel *unReadLabel;

@end

@implementation MessageListTableCell

+ (instancetype)sharedMessageListCell:(UITableView *)tableView
{
    static NSString *ID = @"MessageListTableCell";
    MessageListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[MessageListTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}
- (void)setModel:(EMConversation *)model
{
    /**
    model.conversationId = aermei_admin```````model.ext = {
        avatarURLPath = ,
        nickname =
    }````````model.type = 0`````````lastReciveMsg.ext`````````lastReciveMsg.from = {
        avatarURLPath = http://zsylou.wxwkf.com/Uploads/avatar/58031b9aeed58.jpeg,
        nickname = 管理员,
        uid = 159
    }
     */
    
    _model = model;
    
    /** 群组、单聊共有的 */
    if (model.unreadMessagesCount >= 1) {
        [_unReadLabel setHidden:NO];
        _unReadLabel.text = [NSString stringWithFormat:@"%d",model.unreadMessagesCount];
    }else{
        [_unReadLabel setHidden:YES];
    }
    _timeLabel.text = [self timeChanged:model.latestMessage.localTime];
    /** 群组、单聊有差异的 */
    if (model.type == EMConversationTypeChat) {
        // 单聊
        EMMessage *lastRecivedMsg = [model lastReceivedMessage];
        EMMessage *lastMessage = model.latestMessage;
        KGLog(@"lastRecivedMsg.ext = %@",lastRecivedMsg.ext);
        KGLog(@"lastMessage.ext = %@",lastMessage.ext);
        KGLog(@"model.ext = %@",model.ext);
        
        if (lastRecivedMsg) {
            // 对方有发消息。只有文本消息有ext
            
            _nameLabel.text = [[lastRecivedMsg.ext objectForKey:@"nickname"] description];
            [_headImageV sd_setImageWithURL:[NSURL URLWithString:[lastRecivedMsg.ext objectForKey:@"avatarURLPath"]] placeholderImage:[UIImage imageNamed:@"user_place"]];
            
        }else{
            // 对方没有发消息
            [[YLZGDataManager sharedManager] getOneStudioByUserName:model.conversationId Block:^(ContactersModel *model) {
                _nameLabel.text = model.realname.length>0 ? model.realname : model.nickname;
                [_headImageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
            }];
        }
        
        if (lastMessage) {
            NSString *lastStr = [self getSwitchMessage:lastMessage];
            if (lastStr.length >= 1) {
                _lastMsgLabel.text = lastStr;
            }else{
                _lastMsgLabel.text = @"[GIF]";
            }
        }
        
    }else{
        // 群组
        
        EMMessage *lastMessage = model.latestMessage;
        if (lastMessage) {
            NSString *sendName = [[lastMessage.ext objectForKey:@"nickname"] description];
            NSString *lastStr = [self getSwitchMessage:lastMessage];
            if (lastStr.length >= 1) {
                _lastMsgLabel.text = [NSString stringWithFormat:@"%@：%@",sendName,lastStr];
            }else{
                _lastMsgLabel.text = [NSString stringWithFormat:@"%@：[GIF]",sendName];
            }
        }
        // 通过model.conversationId来获取他信息
        [GroupListManager getGroupInfoByGroupID:model.conversationId Block:^(YLGroup *groupModel) {
            _headImageV.image = [UIImage imageNamed:@"group_add_icon"];
            _nameLabel.text = [NSString stringWithFormat:@"%@·群聊",groupModel.gname];
        }];
    }
}
- (void)setupSubviews
{
    // 头像
    self.headImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"group_back"]];
    self.headImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageV.layer.masksToBounds = YES;
    self.headImageV.layer.cornerRadius = 4;
    [self addSubview:self.headImageV];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@50);
    }];
    
    // 红点
    self.unReadLabel = [[UILabel alloc]init];
    self.unReadLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    [self.unReadLabel setHidden:YES];
    self.unReadLabel.textAlignment = NSTextAlignmentCenter;
    self.unReadLabel.backgroundColor = [UIColor redColor];
    self.unReadLabel.textColor = [UIColor whiteColor];
    self.unReadLabel.layer.masksToBounds = YES;
    self.unReadLabel.layer.cornerRadius = 10;
    [self addSubview:self.unReadLabel];
    [self.unReadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageV.mas_right);
        make.top.equalTo(self.headImageV.mas_top).offset(-2);
        make.width.and.height.equalTo(@20);
    }];
    
    // 昵称
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"火星人";
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(78);
        make.height.equalTo(@21);
        make.bottom.equalTo(self.mas_centerY);
    }];
    
    // 最后一条消息
    self.lastMsgLabel = [[UILabel alloc]init];
    self.lastMsgLabel.text = @"···";
    self.lastMsgLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.lastMsgLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    [self addSubview:self.lastMsgLabel];
    [self.lastMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.equalTo(@21);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-20);
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
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    
    
    
}

- (NSString *)getSwitchMessage:(EMMessage *)emMessage
{
    NSString *messageStr = nil;
    switch (emMessage.body.type) {
        case EMMessageBodyTypeText:
        {
            messageStr = ((EMTextMessageBody *)emMessage.body).text;
            messageStr = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:messageStr];
        }
            break;
        case EMMessageBodyTypeImage:
        {
            messageStr = @"[图片]";
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            messageStr = @"[位置]";
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            messageStr = @"[语音]";
        }
            break;
        case EMMessageBodyTypeVideo:{
            messageStr = @"[视频]";
        }
            break;
        default:
            break;
    }
    return messageStr;
}

- (NSString *)timeChanged:(long long)time
{
    NSString *newTime;
    NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)time];
    NSDate *localDate = [messageDate dateByAddingHours:8];
    NSString *timeStr = [NSString stringWithFormat:@"%@",localDate];
    if ([messageDate isToday]) {
        newTime = [timeStr substringWithRange:NSMakeRange(11, 5)];
    }else if([messageDate isYesterday]){
        newTime = [NSString stringWithFormat:@"昨天 %@",[timeStr substringWithRange:NSMakeRange(11, 5)]];
    }else{
        newTime = [timeStr substringWithRange:NSMakeRange(0, 11)];
        if ([newTime containsString:@":"]) {
            newTime = [newTime stringByReplacingOccurrencesOfString:@":" withString:@"/"];
        }
    }
    return newTime;
}

@end
