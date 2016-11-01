//
//  NoColorTableViewCell.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/5.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "NoColorTableViewCell.h"
#import <Masonry.h>

@interface NoColorTableViewCell ()

@property (strong,nonatomic) NSMutableArray *labelArray;

@end

@implementation NoColorTableViewCell

+ (instancetype)sharedNoColorTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"NoColorTableViewCell";
    NoColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[NoColorTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (void)setModel:(InComeModel *)model
{
    _model = model;
    for (UILabel *label in self.labelArray) {
        if (label.tag == 11) {
            NSString *present = [NSString stringWithFormat:@"%.2f%%",[model.prepro floatValue]/[model.totalin floatValue] * 100];
            label.text = model.isPresent ? model.prepro : present;
        } else if(label.tag == 12){
            NSString *present = [NSString stringWithFormat:@"%.2f%%",[model.ptsell floatValue]/[model.totalin floatValue] * 100];
            label.text = model.isPresent ? model.ptsell : present;
        }else if (label.tag == 13){
            NSString *present = [NSString stringWithFormat:@"%.2f%%",[model.mptsell floatValue]/[model.totalin floatValue] * 100];
            label.text = model.isPresent ? model.mptsell : present;
        }else{
            NSString *present = [NSString stringWithFormat:@"%.2f%%",[model.sptsell floatValue]/[model.totalin floatValue] * 100];
            label.text = model.isPresent ? model.sptsell : present;
        }
    }
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
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@2);
    }];
    
    
    CGFloat space = (SCREEN_WIDTH - 1.5)/4;
    
    
    for (int i = 0; i < 4; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(space + space * i, 0, 0.5, 55)];
        xian.alpha = 0.8f;
        xian.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:xian];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.5 + space * i, 0, space, 55)];
        label.tag = 11 + i;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = SCREEN_WIDTH == 320 ? [UIFont systemFontOfSize:9] : [UIFont systemFontOfSize:15];
        [self addSubview:label];
        
        [self.labelArray addObject:label];
    }
}
- (NSMutableArray *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}


@end
