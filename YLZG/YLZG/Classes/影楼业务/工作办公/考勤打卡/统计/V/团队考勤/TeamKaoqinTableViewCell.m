//
//  TeamKaoqinTableViewCell.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TeamKaoqinTableViewCell.h"

@implementation TeamKaoqinTableViewCell

+ (instancetype)sharedTeamKaoqinTableViewCell:(UITableView *)tableView {
    static NSString * ID = @"TeamKaoqinTableViewCell";
    TeamKaoqinTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TeamKaoqinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self createCell];
    }
    return self;
}

- (void)setModel:(DeptTeamKaoqinModel *)model {
    _model = model;
    _departLabel.text = model.dept;
    _shouldLabel.text = model.should;
    _realLabel.text = model.infact;
    
}

- (void)createCell {
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 44)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_whiteView];
    
    [self getLabelFrame:CGRectMake(10, CGRectGetMaxY(_whiteView.frame), SCREEN_WIDTH-20, 0.5)];
    // 部门
    _departLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4*2, _whiteView.frame.size.height)];
    _departLabel.textColor = RGBACOLOR(43, 135, 227, 1);
    _departLabel.font = [UIFont systemFontOfSize:14];
    _departLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_departLabel];
    
   
    
    [self getLabelFrame:CGRectMake(CGRectGetMaxX(_departLabel.frame), 0, 0.5, _whiteView.frame.size.height)];
    
    _shouldLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_departLabel.frame), 0, (SCREEN_WIDTH-20)/4, _whiteView.frame.size.height)];
    _shouldLabel.textColor = RGBACOLOR(35, 35, 35, 1);
    _shouldLabel.font = [UIFont systemFontOfSize:14];
    _shouldLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_shouldLabel];
    
    [self getLabelFrame:CGRectMake(CGRectGetMaxX(_shouldLabel.frame), 0, 0.5, _whiteView.frame.size.height)];
    
    _realLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_shouldLabel.frame), 0, (SCREEN_WIDTH-20)/4, _whiteView.frame.size.height)];
    _realLabel.textColor = RGBACOLOR(35, 35, 35, 1);
    _realLabel.font = [UIFont systemFontOfSize:14];
    _realLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_realLabel];
}

- (UILabel *)getLabelFrame:(CGRect)frame {
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    [self.contentView addSubview:label];
    return label;
}

@end
