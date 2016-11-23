//
//  TeamZhengchangTableCell.m
//  NewHXDemo
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TeamZhengchangTableCell.h"
#import "UIView+Extension.h"
#import <UIImageView+WebCache.h>


@implementation TeamZhengchangTableCell

+ (instancetype)sharedTeamZhengchangTableCell:(UITableView *)tableView {
    static NSString * ID = @"TeamZhengchangTableCell";
    TeamZhengchangTableCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TeamZhengchangTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryDetailButton];
        self.backgroundColor = [UIColor whiteColor];
        
        [self createCell];
        
    }
    return self;
}

- (void)setModel:(TeamZhengchangdakaModel *)model {
    _model = model;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    _nameLabel.text = [NSString stringWithFormat:@"%@(%@)", model.realname, model.dept];
}

- (void)createCell {
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [self.contentView addSubview:_imageV];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageV.frame)+5, 15, 250, 30)];
    _nameLabel.textColor = RGBACOLOR(34, 34, 34, 1);
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.text = @"fvjfa";
    [self.contentView addSubview:_nameLabel];
    
    
}


@end
