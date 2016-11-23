//
//  TaskListTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskListTableCell.h"
#import "YLZGDataManager.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface TaskListTableCell ()

/** 任务名称 */
@property (strong,nonatomic) UILabel *taskNameLabel;
/** 项目名称 */
@property (strong,nonatomic) UILabel *produceNameL;
/** 时间 */
@property (strong,nonatomic) UILabel *dateLabel;
/** 负责人头像 */
@property (strong,nonatomic) UIImageView *headV;
/** 负责人名字 */
@property (strong,nonatomic) UILabel *nameLabel;


@end

@implementation TaskListTableCell

+ (instancetype)sharedTaskListTableCell:(UITableView *)tableView
{
    static NSString *ID = @"TaskListTableCell";
    TaskListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TaskListTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (void)setTaskListmodel:(TaskListModel *)taskListmodel
{
    _taskListmodel = taskListmodel;
    if (taskListmodel.isMyManager) {
        self.headV.hidden = YES;
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else{
        self.headV.hidden = NO;
        [self.headV sd_setImageWithURL:[NSURL URLWithString:taskListmodel.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
    _taskNameLabel.text = taskListmodel.name;
    _dateLabel.text = [self timeIntervalToDate:taskListmodel.deadline];
    _produceNameL.text = taskListmodel.project;
}
- (void)setProduceDetialModel:(ProduceTaskModel *)produceDetialModel
{
    _produceDetialModel = produceDetialModel;
    self.headV.hidden = NO;
    [self.headV sd_setImageWithURL:[NSURL URLWithString:produceDetialModel.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    [self setAccessoryType:UITableViewCellAccessoryNone];
    _taskNameLabel.text = produceDetialModel.name;
    _dateLabel.text = [self timeIntervalToDate:produceDetialModel.deadline];
    _produceNameL.text = produceDetialModel.project;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    self.taskNameLabel = [[UILabel alloc]init];
    self.taskNameLabel.font = [UIFont systemFontOfSize:14];
    self.taskNameLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    [self addSubview:self.taskNameLabel];
    [self.taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@21);
    }];
    
    UIImageView *dateIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_renwu_shijian"]];
    [self addSubview:dateIcon];
    [dateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.taskNameLabel.mas_left);
        make.top.equalTo(self.taskNameLabel.mas_bottom).offset(7);
        make.width.and.height.equalTo(@15);
    }];
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:13];
    self.dateLabel.textColor = [UIColor grayColor];
    [self addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateIcon.mas_right).offset(2);
        make.centerY.equalTo(dateIcon.mas_centerY);
        make.height.equalTo(@21);
    }];
    
    
    UIImageView *proIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_renwu_xiangmu"]];
    [self addSubview:proIcon];
    [proIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel.mas_right).offset(5);
        make.centerY.equalTo(self.dateLabel.mas_centerY);
        make.width.and.height.equalTo(@15);
    }];
    
    self.produceNameL = [[UILabel alloc]init];
    self.produceNameL.font = self.dateLabel.font;
    self.produceNameL.textColor = self.dateLabel.textColor;
    [self addSubview:self.produceNameL];
    [self.produceNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(proIcon.mas_right).offset(2);
        make.centerY.equalTo(self.dateLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    self.headV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    self.headV.layer.masksToBounds = YES;
    self.headV.layer.cornerRadius = 20;
    self.headV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.headV];
    [self.headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.and.height.equalTo(@40);
        make.top.equalTo(self.mas_top).offset(10);
    }];
    
//    self.nameLabel = [[UILabel alloc]init];
//    self.nameLabel.text =
    
}

- (NSString *)timeIntervalToDate:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    if ([date isToday]) {
        return @"今天";
    }else{
        NSString *origanStr = [NSString stringWithFormat:@"%@",date];
        NSString *time = [origanStr substringWithRange:NSMakeRange(5, 5)];
        return time;
    }
    
}

@end
