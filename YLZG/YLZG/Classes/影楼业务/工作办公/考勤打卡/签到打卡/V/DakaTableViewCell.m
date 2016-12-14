//
//  DakaTableViewCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "DakaTableViewCell.h"



@interface DakaTableViewCell ()

/** 上班时间 */
@property (strong,nonatomic) UILabel *onoffWorkLabel;
/** 打卡按钮 */
@property (strong,nonatomic) UIButton *dakaButton;
/** 是否进入范围 */
@property (strong,nonatomic) UILabel *areaLabel;


@end

@implementation DakaTableViewCell

+ (instancetype)sharedDakaTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"DakaTableViewCell";
    DakaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DakaTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self .backgroundColor = [UIColor whiteColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setupSubViews];
    }
    return self;
}
- (void)setRuleModel:(TodayDakaRuleModel *)ruleModel
{
    _ruleModel = ruleModel;
    _onoffWorkLabel.text = [NSString stringWithFormat:@"上班时间：%@",ruleModel.start];
    
}
- (void)setupSubViews
{
    //上下班时间
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 22, 22)];
    [imageV setImage:[UIImage imageNamed:@"offWorkTime_select"]];
    [self.contentView addSubview:imageV];
    
    self.onoffWorkLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 8, 200, 21)];
    self.onoffWorkLabel.textColor = [UIColor grayColor];
    self.onoffWorkLabel.font = [UIFont systemFontOfSize:13];
    self.onoffWorkLabel.text = @"上班时间 09:00";
    [self.contentView addSubview:self.onoffWorkLabel];
    
    // 按钮
    
    
}

@end
