//
//  TaskProductTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskProductTableCell.h"
#import "YLZGDataManager.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface TaskProductTableCell ()

@property (strong,nonatomic) UIImageView *headV;

@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) UILabel *titleLabel;

@property (strong,nonatomic) UILabel *timeLabel;

@end

@implementation TaskProductTableCell

+ (instancetype)sharedTaskProductCell:(UITableView *)tableView
{
    static NSString *ID = @"TaskProductTableCell";
    TaskProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TaskProductTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setProModel:(TaskProduceListModel *)proModel
{
    _proModel = proModel;
    _titleLabel.text = proModel.name;
    [[YLZGDataManager sharedManager] getOneStudioByUID:proModel.create_user Block:^(ContactersModel *model) {
//        self.textLabel.text = model.realname;
        [_headV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
    }];
    
    _timeLabel.text = [NSString stringWithFormat:@"创建于%@",[self timeIntervalToDate:proModel.create_at]];
    
}


- (NSString *)timeIntervalToDate:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *origanStr = [NSString stringWithFormat:@"%@",date];
    NSString *time = [origanStr substringWithRange:NSMakeRange(0, 16)];
    return time;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH-20, 30)];
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.titleLabel];
    
    self.headV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
    self.headV.layer.masksToBounds = YES;
    self.headV.contentMode = UIViewContentModeScaleAspectFill;
    self.headV.layer.cornerRadius = 20;
    [self addSubview:self.headV];
    [self.headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@40);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = [UIFont systemFontOfSize:12];;
    self.timeLabel. textColor = [UIColor lightGrayColor];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headV.mas_right);
        make.height.equalTo(@21);
        make.top.equalTo(self.headV.mas_bottom);
    }];
}

@end
