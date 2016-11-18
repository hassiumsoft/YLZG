//
//  TaskProductTableCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/17.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TaskProductTableCell.h"

@implementation TaskProductTableCell

+ (instancetype)sharedTaskProductCell:(UITableView *)tableView
{
    static NSString *ID = @"TaskProductTableCell";
    TaskProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TaskProductTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor purpleColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    
}

@end
