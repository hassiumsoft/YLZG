//
//  TeamPaihangbangTableViewCell.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TeamPaihangbangTableViewCell.h"

@implementation TeamPaihangbangTableViewCell

+ (instancetype)sharedTeamPaihangbangTableViewCell:(UITableView *)tableView {
    static NSString * ID = @"TeamPaihangbangTableViewCell";
    TeamPaihangbangTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TeamPaihangbangTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self createCell];
    }
    return self;
}

- (void)setModel:(TeamPaihangbangModel *)model {
    _iconImageV.image = [UIImage imageNamed:model.iconStr];
    _nameLabel.text = model.nameStr;
    _dateLabel.text = model.dateStr;
}

- (void)createCell {
    _iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
    _iconImageV.layer.cornerRadius = 25;
    [self.contentView addSubview:_iconImageV];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageV.frame)+5, CGRectGetMinY(_iconImageV.frame)+15, 150, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = RGBACOLOR(35, 35, 35, 1);
    [self.contentView addSubview:_nameLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, CGRectGetMinY(_nameLabel.frame), 120, 20)];
    _dateLabel.textColor = RGBACOLOR(74, 74, 74, 1);
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_dateLabel];
    
}



@end
