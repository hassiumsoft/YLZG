//
//  MutableSpotTableCell.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/20.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "MutableSpotTableCell.h"
#import <Masonry.h>

@implementation MutableSpotTableCell

+ (instancetype)sharedMutableSpotTableCell:(UITableView *)tableView
{
    static NSString *ID = @"MutableSpotTableCell";
    MutableSpotTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MutableSpotTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(MutableSelectedModel *)model
{
    _model = model;
    _nameLabel.text = model.title;
    if (model.isSelected) {
        [self.selectBtn setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
    } else {
        [self.selectBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    }
}

- (void)setupSubViews
{
 
    self.nameLabel = self.textLabel;
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    
//    if (!self.selectBtn.isSelected) {
//        [self.selectBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
//    }else{
//        [self.selectBtn setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
//    }
    [self addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.and.height.equalTo(@34);
    }];
}

- (void)buttonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    }
    
    
}

@end
