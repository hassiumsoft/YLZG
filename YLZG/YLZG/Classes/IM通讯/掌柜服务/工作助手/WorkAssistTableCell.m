//
//  WorkAssistTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/8.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "WorkAssistTableCell.h"


@interface WorkAssistTableCell ()

/** 标题说明 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 详细说明 */
@property (strong,nonatomic) UILabel *contentLabel;

@end

@implementation WorkAssistTableCell

+ (instancetype)sharedWorkAssistCell:(UITableView *)tableView
{
    static NSString *ID = @"WorkAssistTableCell";
    WorkAssistTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WorkAssistTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
- (void)setLoginModel:(LoginInfoModel *)loginModel
{
    _loginModel = loginModel;
    _titleLabel.text = loginModel.title;
    _contentLabel.text = loginModel.content;
}
- (void)setupSubViews
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, 45 + 60 + 2 + 46)];
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 5;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 15, bottomView.width - 24, 30)];
    self.titleLabel.text = @"5月4日未登录影楼掌柜统计";
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [bottomView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.x, CGRectGetMaxY(self.titleLabel.frame) + 5, self.titleLabel.width, 50)];
    self.contentLabel.numberOfLines = 3;
    self.contentLabel.text = @"昨日未登录人数12人，已登录7人，使用比率35%。\r其中摄影部登录比率最高，财务部登录比率最低。";
    self.contentLabel.textColor = RGBACOLOR(108, 108, 108, 1);
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:self.contentLabel];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    xian.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame) + 10, bottomView.width, 2);
    [bottomView addSubview:xian];
    
    UILabel *visitLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.x, CGRectGetMaxY(xian.frame) - 3, self.titleLabel.width - 40, 46)];
    visitLabel.text = @"查看当天员工使用情况";
    visitLabel.font = [UIFont systemFontOfSize:15];
    visitLabel.textColor = MainColor;
    visitLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [bottomView addSubview:visitLabel];
    
    
    UIImageView *jiantou = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_add"]];
//    jiantou.contentMode = UIViewContentModeScaleAspectFill;
    jiantou.frame = CGRectMake(bottomView.width - 20 - 10, visitLabel.y + 10, 10, 20);
    [bottomView addSubview:jiantou];
}


@end
