//
//  KaoqinTableCell.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/14.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KaoqinModel.h"

typedef NS_ENUM(NSInteger,KaoqinClickType) {
    ChangeMemType, // 修改成员
    EditGuizeType  // 修改规则
};

@protocol KaoqinCellDelegate <NSObject>

- (void)kaoqinDidClickType:(KaoqinClickType)type Model:(KaoqinModel *)model;

@end

@interface KaoqinTableCell : UITableViewCell
/** 组名 */
@property (strong,nonatomic) UILabel *zuNameLabel;
/** 人数 */
@property (strong,nonatomic) UILabel *numLabel;
/** 时间 */
@property (strong,nonatomic) UILabel *timeLabel;
/** 地址 */
@property (strong,nonatomic) UILabel *placeLabel;
/** wifi */
@property (strong,nonatomic) UILabel *wifiLabel;

/** 考勤模型 */
@property (strong,nonatomic) KaoqinModel *model;

@property (weak,nonatomic) id<KaoqinCellDelegate>delegate;
/** 点的是哪一个 */
@property (assign,nonatomic) KaoqinClickType clickType;

+ (instancetype)sharedKaoqinTableCell:(UITableView *)tableView;


@end
