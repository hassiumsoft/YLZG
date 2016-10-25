//
//  FinacialAnalysesCell.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FinacialAnalysesCell.h"
#import <Masonry.h>

@implementation FinacialAnalysesCell

+ (instancetype)sharedFinacialAnalysesCell:(UITableView *)tableView
{
    static NSString *ID = @"FinacialAnalysesCell";
    FinacialAnalysesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FinacialAnalysesCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _bingtuView = [[Huanzhuangbingtu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,250)];
    [self.contentView addSubview:_bingtuView];
    
    NSArray * imageArray = @[@"dingjin_finance",@"bukuan_finance", @"erxiao_finance", @"other_finance"];
    for (int i = 0; i < 4; i++) {
        _imageV = [[UIImageView alloc] init];
        _imageV.frame = CGRectMake(SCREEN_WIDTH/2-50, CGRectGetMaxY(_bingtuView.frame)+30*i, 13, 13);
        _imageV.image = [UIImage imageNamed:imageArray[i]];
        [self.contentView addSubview:_imageV];
    }
    _depositLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageV.frame)+10, CGRectGetMaxY(_bingtuView.frame), 200, 15)];
    _depositLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_depositLabel];
    
    _extraLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageV.frame)+10, CGRectGetMaxY(_bingtuView.frame)+30, 200, 15)];
    _extraLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_extraLabel];
    
    _tsellLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageV.frame)+10, CGRectGetMaxY(_bingtuView.frame)+60, 200, 15)];
    _tsellLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_tsellLabel];
    
    _otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageV.frame)+10, CGRectGetMaxY(_bingtuView.frame)+90, 200, 15)];
    _otherLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_otherLabel];
}



@end
