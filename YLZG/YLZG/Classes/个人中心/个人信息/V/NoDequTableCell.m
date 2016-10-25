//
//  NoDequTableCell.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "NoDequTableCell.h"
#import <Masonry.h>

@implementation NoDequTableCell

+ (instancetype)sharedNoDequTableCell
{
    static NSString *ID = @"NoDequTableCell";
    NoDequTableCell *cell = [[NoDequTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
        
    }
    return self;
}
- (void)setupSubViews
{
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = RGBACOLOR(20, 20, 20, 1);
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    self.contentLabel.text = @"参数内容";
    self.contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-30);
        make.height.equalTo(@21);
    }];
}

@end
