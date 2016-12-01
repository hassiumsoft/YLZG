//
//  OpenOrderTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/30.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "OpenOrderTableCell.h"

@implementation OpenOrderTableCell

+ (instancetype)sharedOpenOrderTableCell:(UITableView *)tableView
{
    static NSString *ID = @"OpenOrderTableCell";
    OpenOrderTableCell *cell = [[OpenOrderTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 4, 100, 40)];
    self.nameLabel.text = @"开单属性";
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.nameLabel];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 4, SCREEN_WIDTH - 115 - 30, 40)];
    self.contentLabel.textColor = RGBACOLOR(37, 37, 37, 1);
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.contentLabel];
}


@end
