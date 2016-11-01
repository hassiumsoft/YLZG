//
//  OutComeColorCell.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/5.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "OutComeColorCell.h"
#import "OutTitleColorView.h"
#import <Masonry.h>

@interface OutComeColorCell ()



@end

@implementation OutComeColorCell

+ (instancetype)sharedFinalTableViewCell:(UITableView *)tableView
{
    static NSString *ID = @"OutComeColorCell";
    OutComeColorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //    [tableView setSeparatorInset:UIEdgeInsetsMake(0, -12, 0, 0)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[OutComeColorCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    
    
    CGFloat space = (SCREEN_WIDTH - 1.5)/6;
    NSArray *titleArr = @[@"办公用品",@"油费",@"工资",@"水电费",@"房租",@"生活费"];
    NSArray *colorArray = @[[UIColor purpleColor], // 办公用品
                            RGBACOLOR(18, 131, 205, 1), // 油费
                            RGBACOLOR(246, 91, 78, 1),  // 工资
                            RGBACOLOR(135, 205, 121, 1),  // 水电费
                            RGBACOLOR(75, 55, 181, 1),  // 房租
                            [UIColor brownColor]     // 生活费
                            ];
    
    
    for (int i = 0; i < titleArr.count; i++) {
        UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(space + space * i, 0, 0.5, 55)];
        xian.alpha = 0.8f;
        xian.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:xian];
        
        OutTitleColorView *colorView = [[OutTitleColorView alloc]initWithFrame:CGRectMake(0.5 + space * i, 0, space, 55) Color:colorArray[i] Title:titleArr[i]];
        [self addSubview:colorView];
        
    }
}


@end
