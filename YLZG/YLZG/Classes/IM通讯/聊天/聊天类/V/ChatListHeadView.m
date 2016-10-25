//
//  ChatListHeadView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ChatListHeadView.h"
#import "NoticeManager.h"
#import <Masonry.h>

@interface ChatListHeadView  ()

@property (strong,nonatomic) UIView *redPoint;

@end


@implementation ChatListHeadView

+ (instancetype)sharedChatListHeadView
{
    return [[self alloc]init];
}

- (void)setIsUnRead:(BOOL)isUnRead
{
    _isUnRead = isUnRead;
    if (isUnRead) {
        // 有未读消息，显示
        [self.redPoint setHidden:NO];
    }else{
        // 没有未读消息，不显示
        [self.redPoint setHidden:YES];
    }
    
}
- (void)reloadData
{
    NSArray *noticeArr = [NoticeManager getAllNoticeInfo];
    if (noticeArr.count >= 1) {
        NoticeModel *model = [noticeArr firstObject];
        self.descLabel.text = [NSString stringWithFormat:@"%@：%@",model.realname,model.title];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    self.imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"group_back"]];
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 4;
    [self addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@50);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.titleLabel.text = @"影楼公告";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(10);
        make.height.equalTo(@21);
        make.bottom.equalTo(self.mas_centerY);
    }];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.text = @"我是卡马克";
    self.descLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.descLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-38);
        make.height.equalTo(@21);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    
    self.redPoint = [[UIView alloc]init];
    self.redPoint.backgroundColor = [UIColor redColor];
    self.redPoint.layer.masksToBounds = YES;
    self.redPoint.layer.cornerRadius = 7;
    [self addSubview:self.redPoint];
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@14);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-18);
    }];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(2);
        make.height.equalTo(@2);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right);
    }];
}

@end
