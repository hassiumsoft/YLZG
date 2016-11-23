//
//  ProduceListTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ProduceListTableCell.h"
#import "YLZGDataManager.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>


@interface ProduceListTableCell ()

@property (strong,nonatomic) UIImageView *headV;

@property (strong,nonatomic) UILabel *timeLabel;

@end

@implementation ProduceListTableCell

+ (instancetype)sharedProduceListCell:(UITableView *)tableView
{
    static NSString *ID = @"ProduceListTableCell";
    ProduceListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ProduceListTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setProModel:(TaskProduceListModel *)proModel
{
    _proModel = proModel;
    self.imageView.image = [UIImage imageNamed:@"ico_renwu_xiangmu"];
    self.textLabel.text = proModel.name;
    [[YLZGDataManager sharedManager] getOneStudioByUID:proModel.create_user Block:^(ContactersModel *model) {
        [_headV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    }];
    
    _timeLabel.text = [NSString stringWithFormat:@"创建于%@",[self timeIntervalToDate:proModel.create_at]];
    
}


- (NSString *)timeIntervalToDate:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *origanStr = [NSString stringWithFormat:@"%@",date];
    NSString *time = [origanStr substringWithRange:NSMakeRange(5, 11)];
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
    
    self.headV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_place"]];
    self.headV.layer.masksToBounds = YES;
    self.headV.contentMode = UIViewContentModeScaleAspectFill;
    self.headV.layer.cornerRadius = 15;
    [self addSubview:self.headV];
    [self.headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@30);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(5);
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
