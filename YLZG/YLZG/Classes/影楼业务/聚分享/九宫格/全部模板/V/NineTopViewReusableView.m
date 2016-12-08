//
//  NineTopViewReusableView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/2.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "NineTopViewReusableView.h"
#import <Masonry.h>



#define TopHeight 160*CKproportion

@interface NineTopViewReusableView ()

@property (strong,nonatomic) UIView *titleView;

@end

@implementation NineTopViewReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = NorMalBackGroudColor;
        [self setupSubViews];
    }
    return self;
}
- (void)setTitleArray:(NSArray *)titleArray
{
    // 中间的空间
    CGFloat Height = self.height - 47 - 16;
    [self.titleView setHeight:Height];
    _titleArray = titleArray;
    
    
    CGFloat spaceH = 15; // 横向间距
    CGFloat spaceZ = 10; // 纵向间距
    CGFloat W = (SCREEN_WIDTH - spaceH*5)/4;  // 宽
    CGFloat H = (Height - 2 * spaceZ)/3;
    for (int i = 0; i < titleArray.count; i++) {
        
        if (i >= 8) {
            return;
        }
        
        NineCategoryModel *model = titleArray[i];
        CGRect frame;
        frame.size.width = W;
        frame.size.height = H + 8;
        frame.origin.x = (i%4) * (frame.size.width + spaceH) + spaceH;
        frame.origin.y = floor(i/4) * (frame.size.height + spaceZ) + spaceZ;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [button setFrame:frame];
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (self.CategoryClick) {
                _CategoryClick(model);
            }
        }];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1.f;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:RGBACOLOR(30, 30, 30, 1) forState:UIControlStateNormal];
        [button setTitle:model.name forState:UIControlStateNormal];
        [self.titleView addSubview:button];
        
    }
}
- (void)setupSubViews
{
    // 标签数组集
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH, TopHeight - 16)];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.userInteractionEnabled = YES;
    [self addSubview:titleView];
    self.titleView = titleView;
    // 热门模板
    UIView *bottomV = [[UIView alloc]init];
    bottomV.userInteractionEnabled = YES;
    bottomV.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.mas_bottom).offset(-4);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (self.DidClickBlock) {
            _DidClickBlock();
        }
    }];
    [bottomV addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 40)];
    label.text = @"热门模板";
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.textColor = RGBACOLOR(67, 67,67, 1);
    [bottomV addSubview:label];
    
    UIImageView *rightIconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_gg_chakan"]];
    [self addSubview:rightIconV];
    [rightIconV setFrame:CGRectMake(SCREEN_WIDTH - 35, 10, 30, 20)];
    [bottomV addSubview:rightIconV];
    
}



@end
