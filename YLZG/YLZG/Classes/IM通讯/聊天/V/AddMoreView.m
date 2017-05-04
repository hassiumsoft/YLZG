//
//  AddMoreView.m
//  YLZG
//
//  Created by Chan_Sir on 2017/5/4.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import "AddMoreView.h"
#import "NormalTableCell.h"

@interface AddMoreView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray *array;

@end

@implementation AddMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CoverColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.array = @[@"发起群聊",@"添加朋友"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 150, 64, 150, 100)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = HWRandomColor;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 50;
    [self addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.label.text = self.array[indexPath.row];
    cell.imageV.image = [UIImage imageNamed:@"user_place"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeFromSuperview];
}

@end
