//
//  RightBadgeView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "RightBadgeView.h"
#import "OfflineDataManager.h"
#import <Masonry.h>

@implementation RightBadgeView

+ (instancetype)sharedRightBadgeView
{
    
    RightBadgeView *rightBar = [[RightBadgeView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightbar_order"]];
    imageV.frame = CGRectMake(2, 2, 26, 26);
    [rightBar addSubview:imageV];
    
    NSArray *array = [OfflineDataManager getAllOffLineOrderFromSandBox];
    if (array.count > 0) {
        UILabel *badgeLabel = [UILabel new];
        badgeLabel.text = [NSString stringWithFormat:@"%d",(int)array.count];
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.backgroundColor = [UIColor redColor];
        badgeLabel.layer.masksToBounds = YES;
        badgeLabel.layer.cornerRadius = 12;
        badgeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        [rightBar addSubview:badgeLabel];
        [badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rightBar.mas_left);
            make.top.equalTo(rightBar.mas_top);
            make.width.and.height.equalTo(@24);
        }];
        
    }
    
    return rightBar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
