//
//  FinalTableViewCell.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/5.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "FinalTableViewCell.h"
#import "TitleColorView.h"
#import <Masonry.h>

@interface FinalTableViewCell ()

@property (strong,nonatomic) TitleColorView *colorView;

@end

@implementation FinalTableViewCell

+ (instancetype)sharedFinalTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"FinalTableViewCell";
    FinalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    [tableView setSeparatorInset:UIEdgeInsetsMake(0, -12, 0, 0)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[FinalTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    NSArray *titleArr = @[@"前期销售",@"摄影二次销售",@"化妆二次销售",@"选片二次销售"];
    NSArray *colorArray = @[[UIColor purpleColor], // 前期
                            [UIColor brownColor], // 摄影
                            RGBACOLOR(246, 91, 78, 1),  // 化妆
                            RGBACOLOR(135, 205, 121, 1),];  // 取件
    for (int i = 0; i < titleArr.count; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(space + space * i, 0, 0.5, 55)];
        xian.alpha = 0.8f;
        xian.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:xian];
        
        self.colorView = [[TitleColorView alloc]initWithFrame:CGRectMake(0.5 + space * i, 0, space, 55) Color:colorArray[i] Title:titleArr[i]];
        [self addSubview:self.colorView];
        
    }
}
@end
