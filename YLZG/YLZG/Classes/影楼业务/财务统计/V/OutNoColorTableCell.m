//
//  OutNoColorTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/5.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "OutNoColorTableCell.h"
#import <Masonry.h>

@interface OutNoColorTableCell ()

@property (strong,nonatomic) NSMutableArray *labelArray;

@end

@implementation OutNoColorTableCell

+ (instancetype)sharedOutNoColorTableCell:(UITableView *)tableView
{
    static NSString *ID = @"OutNoColorTableCell";
    OutNoColorTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[OutNoColorTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
- (void)setOutModel:(OutComeModel *)outModel
{
    _outModel = outModel;
    
    for (UILabel *label in self.labelArray) {
        if (label.tag == 21) {
            NSString *present = [NSString stringWithFormat:@"%.2f%%",[outModel.office floatValue]/[outModel.totalout floatValue] * 100];
            label.text = outModel.isPresent ? outModel.office : present;
        } else if(label.tag == 22){
            NSString *present = [NSString stringWithFormat:@"%.2f%%",[outModel.oil floatValue]/[outModel.totalout floatValue] * 100];
            label.text = outModel.isPresent ? outModel.oil : present;
        }else if (label.tag == 23){
            NSString *present = [NSString stringWithFormat:@"%.2f%%",[outModel.salary floatValue]/[outModel.totalout floatValue] * 100];
            label.text = outModel.isPresent ? outModel.salary : present;
        }else if(label.tag == 24){
            NSString *present = [NSString stringWithFormat:@"%.2f%%",[outModel.water floatValue]/[outModel.totalout floatValue] * 100];
            label.text = outModel.isPresent ? outModel.water : present;
        }else if (label.tag == 25){
            NSString *present = [NSString stringWithFormat:@"%.2f%%",[outModel.rent floatValue]/[outModel.totalout floatValue] * 100];
            label.text = outModel.isPresent ? outModel.rent : present;
        }else{
            NSString *present = [NSString stringWithFormat:@"%.2f%%",[outModel.live floatValue]/[outModel.totalout floatValue] * 100];
            label.text = outModel.isPresent ? outModel.live : present;
        }
    }
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
    
    
    CGFloat space = (SCREEN_WIDTH - 2.5)/6;
    
    
    for (int i = 0; i < 6; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(space + space * i + 0.5, 0, 0.5, 55)];
        xian.alpha = 0.8f;
        xian.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:xian];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.5 + space * i, 0, space, 55)];
        label.tag = 21 + i;
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
