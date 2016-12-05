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


@interface NineCareTableViewCell ()

/** 背景图片 */
@property (strong,nonatomic) UIImageView *backImageV;

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
