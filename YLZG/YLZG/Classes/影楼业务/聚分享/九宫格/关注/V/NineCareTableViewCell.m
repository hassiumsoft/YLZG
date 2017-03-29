//
//  NineCareTableViewCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/4.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NineCareTableViewCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "UIImage+Category.h"


@interface NineCareTableViewCell ()

/** 背景图片 */
@property (strong,nonatomic) UIImageView *backImageV;
/** 标题 */
@property (strong,nonatomic) UILabel *nameLabel;

@end

@implementation NineCareTableViewCell

+ (instancetype)sharedNineCell:(UITableView *)tableView
{
    static NSString *ID = @"NineCareTableViewCell";
    NineCareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NineCareTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}
- (void)setModel:(NineHotCommentModel *)model
{
    _model = model;
    _nameLabel.text = model.name;
    if ([model.id isEqualToString:@"group"]) {
        _backImageV.image = [UIImage imageNamed:model.thumb];
    }else{
        [_backImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"reg-fb-bg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            _backImageV.image = [UIImage boxblurImage:image withBlurNumber:0.5];
        }];
    }
    
}
- (void)setTeamClassModel:(TeamClassModel *)teamClassModel
{
    _teamClassModel = teamClassModel;
    _nameLabel.text = teamClassModel.name;
    
}
- (void)setupSubViews
{
    self.backImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reg-fb-bg"]];
    self.backImageV.layer.masksToBounds = YES;
    self.backImageV.layer.cornerRadius = 4;
//    self.backImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.backImageV];
    [self.backImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.top.equalTo(self.mas_top).offset(6);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:28];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backImageV.mas_left);
        make.right.equalTo(self.backImageV.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
- (UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
