//
//  HomeHeadView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/8.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HomeHeadView.h"
#import "NormalconButton.h"
#import "OfflineDataManager.h"

static CGFloat marginNum = 1;
static CGFloat topViewH = 100;

@interface HomeHeadView ()


@end

@implementation HomeHeadView

+ (instancetype)sharedHomeHeadView
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = NavColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
//    HomeHeadView *headView = [[HomeHeadView alloc]init];
    NSArray *nameArray = [NSArray arrayWithObjects:@"开单",@"查询",@"预约", nil];
    NSArray *iconArray = [NSArray arrayWithObjects:@"open_order",@"search_order",@"pre_order", nil];
    
    CGFloat topBtnW = (SCREEN_WIDTH - 4*marginNum)/3;
    CGRect topFrame;
    for (int i = 0; i < nameArray.count; i++) {
        NormalconButton *button = [NormalconButton sharedHomeIconView];
        button.userInteractionEnabled = YES;
        topFrame.origin.x = (i%3) * (topBtnW + marginNum) + marginNum;
        topFrame.origin.y = 0;
        topFrame.size.width = topBtnW;
        topFrame.size.height = topViewH;
        [button setFrame:topFrame];
        button.tag = i + 1;
        button.count = 0;
        button.iconView.image = [UIImage imageNamed:iconArray[i]];
        button.label.text = nameArray[i];
        [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
    }
}
- (void)ButtonClick:(UIButton *)sender
{
    if (self.ButtonClickBlock) {
        _ButtonClickBlock(sender.tag);
    }
}


@end
