//
//  EditPaibanTableCell.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/13.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "EditPaibanTableCell.h"
#import <Masonry.h>


@implementation EditPaibanTableCell

+ (instancetype)sharedEditPaibanTableCell:(UITableView *)tableView
{
    static NSString *ID = @"EditPaibanTableCell";
    EditPaibanTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    if (!cell) {
        cell = [[EditPaibanTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(GudingPaibanModel *)model
{
    _model = model;
    if (model.isSelected) {
        [self.selectedBtn setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
    }else{
        [self.selectedBtn setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
    }
    _weekLabel.text = model.week;
    _banciNameLabel.text = model.classname;
    if (model.isSelected) {
        _timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.start,model.end];
        
    }else{
        _timeLabel.text = @"休息";
    }
    
}

- (void)setupSubViews
{
    
    self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectedBtn];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.and.height.equalTo(@35);
    }];
    
    self.weekLabel = [[UILabel alloc]init];
    self.weekLabel.text = @"每周一";
    self.weekLabel.textColor = RGBACOLOR(10, 10, 10, 1);
    self.weekLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.weekLabel];
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@23);
        make.left.equalTo(self.selectedBtn.mas_right).offset(8);
    }];
    
    self.banciNameLabel = [[UILabel alloc]init];
    self.banciNameLabel.text = @"早班";
    self.banciNameLabel.textColor = [UIColor grayColor];
    self.banciNameLabel.font = [UIFont systemFontOfSize:14];
    self.banciNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.banciNameLabel];
    CGFloat kkk;
    if (SCREEN_WIDTH == 320) {
        kkk = 25 * CKproportion;
    }else{
        kkk = 50 * CKproportion;
    }
    [self.banciNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@23);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    // 上下班时间
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.text = @"09：00";
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@23);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    
}

#pragma mark - 点击选中
- (void)selectedBtnClick:(UIButton *)sender
{
    _model.isSelected = !_model.isSelected;
    if (!_model.isSelected) {
        [sender setImage:[UIImage imageNamed:@"EditControl"] forState:UIControlStateNormal];
        self.model.isSelected = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"EditControlSelected"] forState:UIControlStateNormal];
        self.model.isSelected = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(editPaibanCellWithModel:)]) {
        [self.delegate editPaibanCellWithModel:self.model];
    }
}

@end
