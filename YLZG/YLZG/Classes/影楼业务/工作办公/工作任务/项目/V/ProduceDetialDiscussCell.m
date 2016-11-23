//
//  ProduceDetialDiscussCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ProduceDetialDiscussCell.h"

@implementation ProduceDetialDiscussCell

+ (instancetype)sharedDetialDiscussCell:(UITableView *)tableView
{
    static NSString *ID = @"ProduceDetialDiscussCell";
    ProduceDetialDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ProduceDetialDiscussCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}
- (void)setDiscussModel:(ProduceDiscussModel *)discussModel
{
    _discussModel = discussModel;
    self.textLabel.text = discussModel.content;
    self.detailTextLabel.text = [self timeIntervalToDate:discussModel.create_at];
}
- (NSString *)timeIntervalToDate:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *origanStr = [NSString stringWithFormat:@"%@",date];
    NSString *time = [origanStr substringWithRange:NSMakeRange(5, 11)];
    return time;
}
- (void)setupSubViews
{
    
}

@end
