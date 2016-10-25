//
//  GroupTableViewCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "GroupTableViewCell.h"
#import <Masonry.h>
#import "YLZGDataManager.h"
#import <UIImageView+WebCache.h>
#import "ImageBrowser.h"


@interface GroupTableViewCell ()

/** 群名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 群描述 */
@property (strong,nonatomic) UILabel *descLabel;
/** 群主头像 */
@property (strong,nonatomic) UIImageView *owerHeadV;
/** 群主 */
@property (strong,nonatomic) UILabel *owerLabel;

@end

@implementation GroupTableViewCell

+ (instancetype)sharedGroupTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"GroupTableViewCell";
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[GroupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}
- (void)setModel:(YLGroup *)model
{
    _model = model;
    _nameLabel.text = model.gname;
    _descLabel.text = model.dsp;
    _owerLabel.text = model.owner;
    [[YLZGDataManager sharedManager] getOneStudioByUserName:model.owner Block:^(ContactersModel *model) {
        _owerLabel.text = model.realname;
        if ([model.gender intValue] == 1) {
            [_owerHeadV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
        }else{
            [_owerHeadV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"male_place"]];
        }
    }];
}

- (void)setupSubViews
{
//    RGBACOLOR(2, 42, 39, 1),RGBACOLOR(167, 67, 79, 1),RGBACOLOR(110, 3, 25, 1),RGBACOLOR(92, 25, 166, 1),RGBACOLOR(25, 159, 187, 1)
    
    NSArray *colorArr = @[RGBACOLOR(2, 42, 39, 1),RGBACOLOR(167, 67, 79, 1),RGBACOLOR(110, 3, 25, 1),RGBACOLOR(92, 25, 166, 1),RGBACOLOR(25, 159, 187, 1),RGBACOLOR(12, 12, 12, 1),NavColor];
    int i = arc4random() % colorArr.count;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, 80)];
    view.backgroundColor = colorArr[i];
    view.layer.cornerRadius = 6;
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    
    
    // 群主
    self.owerHeadV = [[UIImageView alloc]init];
    self.owerHeadV.backgroundColor = [UIColor whiteColor];
    self.owerHeadV.userInteractionEnabled = YES;
    self.owerHeadV.layer.masksToBounds = YES;
    self.owerHeadV.layer.cornerRadius = 25;
    [view addSubview:self.owerHeadV];
    [self.owerHeadV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(5);
        make.width.and.height.equalTo(@50);
        make.centerY.equalTo(view.mas_centerY).offset(-10);
    }];
    
    self.owerLabel = [[UILabel alloc]init];
    self.owerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.owerLabel.textColor = [UIColor whiteColor];
    [view addSubview:self.owerLabel];
    [self.owerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.owerHeadV.mas_centerX);
        make.height.equalTo(@21);
        make.top.equalTo(self.owerHeadV.mas_bottom);
    }];
    
    
    // 群名称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 5, view.width - 60, 30)];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [view addSubview:self.nameLabel];

    // 群描述
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.descLabel.numberOfLines = 2;
    self.descLabel.textColor = [UIColor whiteColor];
    [view addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.width.equalTo(@(self.nameLabel.width));
        make.height.equalTo(@42);
    }];
    

}
@end
