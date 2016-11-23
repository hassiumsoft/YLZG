//
//  ProduceDetialFileCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ProduceDetialFileCell.h"

@implementation ProduceDetialFileCell

+ (instancetype)sharedProduceDetialFileCell:(UITableView *)tableView
{
    static NSString *ID = @"ProduceDetialFileCell";
    ProduceDetialFileCell *CELL = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!CELL) {
        CELL = [[ProduceDetialFileCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return CELL;
}
- (void)setFileModel:(ProduceFileModel *)fileModel
{
    _fileModel = fileModel;
    self.textLabel.text = fileModel.nickname;
    self.detailTextLabel.text = [self timeIntervalToDate:fileModel.upload_at];
}
- (NSString *)timeIntervalToDate:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *origanStr = [NSString stringWithFormat:@"%@",date];
    NSString *time = [origanStr substringWithRange:NSMakeRange(5, 11)];
    return time;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    self.backgroundColor = [UIColor whiteColor];
}

@end
