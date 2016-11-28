//
//  TaskDiscussTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/28.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskDiscussTableCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>


@interface TaskDiscussTableCell ()

/** 评论人头像 */
@property (strong,nonatomic) UIImageView *headV;
/** 评论人昵称 */
@property (strong,nonatomic) UILabel *discussNameL;
/** 评论时间 */
@property (strong,nonatomic) UILabel *timeLabel;
/** 评论内容---文字 */
@property (strong,nonatomic) UILabel *discussTitleL;



@end

@implementation TaskDiscussTableCell

+ (instancetype)sharedTaskDiscussCell:(UITableView *)tableView
{
    static NSString *ID = @"TaskDiscussTableCell";
    TaskDiscussTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TaskDiscussTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = NorMalBackGroudColor;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubviews];
    }
    return self;
}
- (void)setDiscussModel:(TaskDetialDiscussModel *)discussModel
{
    _discussModel = discussModel;
    [_headV sd_setImageWithURL:[NSURL URLWithString:discussModel.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    _discussNameL.text = discussModel.nickname;
    _timeLabel.text = [self timeIntervalToDate:discussModel.create_at];
    _discussTitleL.text = discussModel.content;
    if (discussModel.am_type == 1) {
        // 附件类型是图片
        [self createFujianView:discussModel];
    }else if (discussModel.am_type == 2){
        // 附件类型是文件
        [self createFujianView:discussModel];
    }
    
}
- (void)createFujianView:(TaskDetialDiscussModel *)disModel
{
    if (disModel.am_type == 1) {
        // 附件是图片
        UIImageView *disImageView = [[UIImageView alloc]init];
        disImageView.userInteractionEnabled = YES;
        [disImageView sd_setImageWithURL:[NSURL URLWithString:disModel.am_thumb] placeholderImage:[UIImage imageNamed:@"task_image_place"]];
        [self addSubview:disImageView];
        [disImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.discussTitleL.mas_left);
            make.top.equalTo(self.discussTitleL.mas_bottom);
            make.width.equalTo(@80);
            make.height.equalTo(@80);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if (self.DidBlock) {
                _DidBlock(disModel.am_type);
            }
        }];
        [disImageView addGestureRecognizer:tap];
        
        // 图片名称
        UILabel *fileNameL = [[UILabel alloc]init];
        fileNameL.text = disModel.am_name;
        fileNameL.textColor = [UIColor grayColor];
        fileNameL.font = [UIFont systemFontOfSize:12];
        [self addSubview:fileNameL];
        [fileNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(disImageView.mas_right).offset(5);
            make.bottom.equalTo(disImageView.mas_bottom);
            make.height.equalTo(@21);
        }];
    }else{
        // 附件是文件类型
        UIImageView *disFileView = [[UIImageView alloc]init];
        disFileView.userInteractionEnabled = YES;
        [disFileView sd_setImageWithURL:[NSURL URLWithString:disModel.am_thumb] placeholderImage:[UIImage imageNamed:@"task_file_place"]];
        [self addSubview:disFileView];
        [disFileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.discussTitleL.mas_left);
            make.top.equalTo(self.discussTitleL.mas_bottom);
            make.width.equalTo(@80);
            make.height.equalTo(@80);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if (self.DidBlock) {
                _DidBlock(disModel.am_type);
            }
        }];
        [disFileView addGestureRecognizer:tap];
        
        // 文件名称
        UILabel *fileNameL = [[UILabel alloc]init];
        fileNameL.text = disModel.am_name;
        fileNameL.textColor = [UIColor grayColor];
        fileNameL.font = [UIFont systemFontOfSize:12];
        [self addSubview:fileNameL];
        [fileNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(disFileView.mas_right).offset(5);
            make.bottom.equalTo(disFileView.mas_bottom);
            make.height.equalTo(@21);
        }];
        
    }
    
}
- (void)setupSubviews
{
    // 评论人头像
    self.headV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    self.headV.layer.masksToBounds = YES;
    self.headV.layer.cornerRadius = 15;
    [self addSubview:self.headV];
    [self.headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.width.and.height.equalTo(@30);
        make.top.equalTo(self.mas_top).offset(1);
    }];
    // 评论人昵称
    self.discussNameL = [[UILabel alloc]init];
    self.discussNameL.textColor = RGBACOLOR(21, 21, 21, 1);
    self.discussNameL.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.discussNameL];
    [self.discussNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headV.mas_right).offset(5);
        make.height.equalTo(@21);
        make.centerY.equalTo(self.headV.mas_centerY);
    }];
    // 评论时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discussNameL.mas_right).offset(5);
        make.height.equalTo(@21);
        make.centerY.equalTo(self.headV.mas_centerY);
    }];
    // 评论内容-文字
    self.discussTitleL = [[UILabel alloc]init];
    self.discussTitleL.font = [UIFont systemFontOfSize:14];
    self.discussTitleL.textColor = RGBACOLOR(38, 38, 38, 1);
    [self addSubview:self.discussTitleL];
    [self.discussTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headV.mas_bottom);
        make.left.equalTo(self.discussNameL.mas_left);
        make.height.equalTo(@21);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
    
}
- (NSString *)timeIntervalToDate:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    if ([date isToday]) {
        
        return @"今天";
    }else{
        NSString *origanStr = [NSString stringWithFormat:@"%@",date];
        NSString *time = [origanStr substringWithRange:NSMakeRange(5, 11)];
        return time;
    }
    
}

@end
