//
//  WorkSecretTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "WorkSecretTableCell.h"

@implementation WorkSecretTableCell

+ (instancetype)sharedWorkCell:(UITableView *)tableView
{
    static NSString *ID = @"WorkSecretTableCell";
    WorkSecretTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WorkSecretTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = NorMalBackGroudColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, 45 + 80 + 2 + 46)];
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 5;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    
    
    
}


@end
