//
//  DongtaiListTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2017/1/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "DongtaiListTableCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface DongtaiListTableCell ()

/** 项目名称 */
@property (strong,nonatomic) UILabel *projectNameL;
/** 操作人员的头像 */
@property (strong,nonatomic) UIImageView *headView;
/** 操作内容 */
@property (strong,nonatomic) UILabel *contentLabel;
/** 操作时间 */
@property (strong,nonatomic) UILabel *timeLabel;
/** 任务名称 */
@property (strong,nonatomic) UILabel *taskLabel;
/** 回复内容 */
@property (strong,nonatomic) UILabel *replayLabel;


@end

@implementation DongtaiListTableCell

+ (instancetype)sharedDongtaiListCell:(UITableView *)tableView
{
    static NSString *ID = @"DongtaiListTableCell";
    DongtaiListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[DongtaiListTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setDetialModel:(TodayDongtaiModel *)detialModel
{
    _detialModel = detialModel;
    _projectNameL.text = [NSString stringWithFormat:@"项目：%@",detialModel.project];
    [_headView sd_setImageWithURL:[NSURL URLWithString:detialModel.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    _contentLabel.text = detialModel.content;
    NSString *allDate = [self timeIntervalToDate:detialModel.time];
    _timeLabel.text = [allDate substringWithRange:NSMakeRange(10, 6)];
    _taskLabel.text = [NSString stringWithFormat:@"     %@",detialModel.item_name];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    //  项目名称
    self.projectNameL = [[UILabel alloc]init];
    self.projectNameL.textAlignment = NSTextAlignmentRight;
    self.projectNameL.font = [UIFont systemFontOfSize:13];
    self.projectNameL.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.projectNameL];
    [self.projectNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.height.equalTo(@24);
        make.top.equalTo(self.mas_top);
    }];
    
    UIView *xian = [[UIView alloc]init];
    xian.backgroundColor = NorMalBackGroudColor;
    [self.contentView addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.projectNameL.mas_left).offset(-8);
        make.centerY.equalTo(self.projectNameL.mas_centerY);
        make.height.equalTo(@1);
    }];
    
    // 操作者头像
    self.headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.cornerRadius = 20;
    [self.contentView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.projectNameL.mas_bottom).offset(10);
        make.width.and.height.equalTo(@40);
    }];
    
    // 内容
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textColor = RGBACOLOR(108, 108, 108, 1);
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_right).offset(10);
        make.bottom.equalTo(self.headView.mas_centerY);
        make.height.equalTo(@24);
    }];
    
    // 时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headView.mas_centerX);
        make.top.equalTo(self.headView.mas_bottom);
        make.height.equalTo(@21);
        make.width.equalTo(@50);
    }];
    
    // 任务名称
    self.taskLabel = [[UILabel alloc]init];
    self.taskLabel.backgroundColor = RGBACOLOR(235, 235, 241, 1);
    self.taskLabel.font = [UIFont systemFontOfSize:15];
    self.taskLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:self.taskLabel];
    [self.taskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.height.equalTo(@40);
    }];
    
    
}

@end
