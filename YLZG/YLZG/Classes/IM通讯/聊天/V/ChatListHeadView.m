//
//  ChatListHeadView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ChatListHeadView.h"
#import <Masonry.h>

@interface ChatListHeadView  ()


/** 工作助手最后一条信息 */
@property (strong,nonatomic) UILabel *workLastMsgLabel;

/** 小秘书最后一条信息 */
@property (strong,nonatomic) UILabel *mishuLastMsgLabel;

@end


@implementation ChatListHeadView


- (void)setLoginModel:(LoginInfoModel *)loginModel
{
    _loginModel = loginModel;
    
    _workLastMsgLabel.text = [NSString stringWithFormat:@"%@：%@",loginModel.title,loginModel.content];
}

- (void)setVersionModel:(VersionInfoModel *)versionModel
{
    _versionModel = versionModel;
    _mishuLastMsgLabel.text = [NSString stringWithFormat:@"%@：%@",versionModel.title,versionModel.content];
    
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
    
    // 掌柜小助手
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height/2)];
    view1.userInteractionEnabled = YES;
    view1.backgroundColor = [UIColor whiteColor];
    [self addSubview:view1];
    
    UITapGestureRecognizer *zhushou = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock(WorkZhushouType);
        }
    }];
    [view1 addGestureRecognizer:zhushou];
    
    UIImageView *xian1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian1.frame = CGRectMake(0, view1.height - 1, self.width, 1);
    [view1 addSubview:xian1];
    
    
    UIImageView *iconView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_work_assistant"]];
    iconView1.layer.masksToBounds = YES;
    iconView1.layer.cornerRadius = 4;
    [view1 addSubview:iconView1];
    [iconView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(view1.mas_centerY);
        make.width.and.height.equalTo(@50);
    }];
    
    UILabel *titleLabel1 = [[UILabel alloc]init];
    titleLabel1.text = @"掌柜工作助手";
    titleLabel1.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [view1 addSubview:titleLabel1];
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(78);
        make.height.equalTo(@21);
        make.bottom.equalTo(iconView1.mas_centerY);
    }];
    
    self.workLastMsgLabel = [[UILabel alloc]init];
    self.workLastMsgLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.workLastMsgLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    [view1 addSubview:self.workLastMsgLabel];
    [self.workLastMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel1.mas_left);
        make.top.equalTo(titleLabel1.mas_bottom);
        make.height.equalTo(@21);
        make.right.equalTo(view1.mas_right).offset(-38);
    }];
    
    
    // 掌柜小秘书
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.height/2, self.width, self.height/2)];
    view2.userInteractionEnabled = YES;
    view2.backgroundColor = [UIColor whiteColor];
    [self addSubview:view2];
    
    UITapGestureRecognizer *mishu = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.ClickBlock) {
            _ClickBlock(WorkMishuType);
        }
    }];
    [view2 addGestureRecognizer:mishu];
    
    UIImageView *iconView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_minisec"]];
    iconView2.layer.masksToBounds = YES;
    iconView2.layer.cornerRadius = 4;
    [view2 addSubview:iconView2];
    [iconView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(view2.mas_centerY);
        make.width.and.height.equalTo(@50);
    }];
    
    UILabel *titleLabel2 = [[UILabel alloc]init];
    titleLabel2.text = @"掌柜小秘书";
    titleLabel2.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [view2 addSubview:titleLabel2];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(78);
        make.height.equalTo(@21);
        make.bottom.equalTo(iconView2.mas_centerY);
    }];
    
    self.mishuLastMsgLabel = [[UILabel alloc]init];
    self.mishuLastMsgLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.mishuLastMsgLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    [view2 addSubview:self.mishuLastMsgLabel];
    [self.mishuLastMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel2.mas_left);
        make.top.equalTo(titleLabel2.mas_bottom);
        make.height.equalTo(@21);
        make.right.equalTo(view2.mas_right).offset(-38);
    }];

    
    UIImageView *xian2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian2.frame = CGRectMake(0, view2.height - 1, self.width, 1);
    [view2 addSubview:xian2];
    
    
    
}

@end
