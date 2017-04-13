//
//  TodayFinaceCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TodayFinaceCell.h"
#import "CaiwuDetialModel.h"

@interface TodayFinaceCell ()

@property (strong,nonatomic) UILabel *typeLabel;

@property (strong,nonatomic) UILabel *listLabel;

@property (strong,nonatomic) UILabel *priceLabel;

@end


@implementation TodayFinaceCell

+ (instancetype)sharedTodayFinaceCell:(UITableView *)tableView
{
    static NSString *ID = @"TodayFinaceCell";
    TodayFinaceCell *CELL = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!CELL) {
        CELL = [[TodayFinaceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return CELL;
}
- (void)setModel:(TodayFinaceDetialModel *)model
{
    _model = model;
    _typeLabel.text = model.type;
    _listLabel.text = [NSString stringWithFormat:@"%d条明细",(int)model.list.count];
    float sumPrice = 0;
    if (model.list.count >= 1) {
        for (CaiwuDetialModel *caiwuModel in model.list) {
            sumPrice += [caiwuModel.money floatValue];
        }
    }else{
        sumPrice = 0;
    }
    _priceLabel.text = [NSString stringWithFormat:@"￥%g",sumPrice];
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

- (void)setupSubViews
{
    
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, 150, 21)];
    self.typeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.typeLabel];
    
    self.listLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.typeLabel.frame), 150, 21)];
    self.listLabel.textColor = RGBACOLOR(87, 87, 87, 1);
    self.listLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [self addSubview:self.listLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, 10, 100, 25)];
    self.priceLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.priceLabel.textColor = WechatRedColor;
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.priceLabel];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [xian setFrame:CGRectMake(0, 60, SCREEN_WIDTH, 2)];
    [self addSubview:xian];
}

@end
