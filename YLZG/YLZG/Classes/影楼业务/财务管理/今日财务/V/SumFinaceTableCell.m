//
//  SumFinaceTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/9.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SumFinaceTableCell.h"


@interface SumFinaceTableCell ()

/** 收入 */
@property (strong,nonatomic) UILabel *IncomeLabel;
/** 支出 */
@property (strong,nonatomic) UILabel *OutcomeLabel;
/** 净利润 */
@property (strong,nonatomic) UILabel *NetinLabel;

@end

@implementation SumFinaceTableCell

+ (instancetype)sharedSumFinaceTableCell:(UITableView *)tableView
{
    static NSString *ID = @"SumFinaceTableCell";
    SumFinaceTableCell *CELL = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!CELL) {
        CELL = [[SumFinaceTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return CELL;
}
- (void)setModel:(TodayFinaceModel *)model
{
    _model = model;
    if (!([model.income intValue] > 0)) {
        _IncomeLabel.text = @"0";
        _OutcomeLabel.text = @"0";
        _NetinLabel.text = @"0";
    }else{
        _IncomeLabel.text = model.income;
        _OutcomeLabel.text = model.expend;
        _NetinLabel.text = model.netin;
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 8)];
    bottomV.backgroundColor = NorMalBackGroudColor;
    [self addSubview:bottomV];
    
    
    NSArray * titleArr = @[@"总收入", @"总支出", @"净收入"];
    for (int i = 0; i < titleArr.count; i++) {
        CGRect frame;
        frame.origin.x = SCREEN_WIDTH/3 * i;
        frame.origin.y = 0;
        frame.size.width = SCREEN_WIDTH/3;
        frame.size.height = 100 * 0.35;
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.text = titleArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        
        if (i == 0) {
            // 总收入
            frame.origin.y = 35;
            frame.size.height = 100 * 0.65;
            self.IncomeLabel = [[UILabel alloc]initWithFrame:frame];
            self.IncomeLabel.textAlignment = NSTextAlignmentCenter;
            self.IncomeLabel.font = [UIFont boldSystemFontOfSize:18];
            [self addSubview:self.IncomeLabel];
        }else if (i == 1){
            // 总支出
            frame.origin.y = 35;
            frame.size.height = 100 * 0.65;
            self.OutcomeLabel = [[UILabel alloc]initWithFrame:frame];
            self.OutcomeLabel.textAlignment = NSTextAlignmentCenter;
            self.OutcomeLabel.font = [UIFont boldSystemFontOfSize:18];
            [self addSubview:self.OutcomeLabel];
        }else {
            // 净利润
            frame.origin.y = 35;
            frame.size.height = 100 * 0.65;
            self.NetinLabel = [[UILabel alloc]initWithFrame:frame];
            self.NetinLabel.textAlignment = NSTextAlignmentCenter;
            self.NetinLabel.font = [UIFont boldSystemFontOfSize:18];
            [self addSubview:self.NetinLabel];
        }
    }
    
}

@end
