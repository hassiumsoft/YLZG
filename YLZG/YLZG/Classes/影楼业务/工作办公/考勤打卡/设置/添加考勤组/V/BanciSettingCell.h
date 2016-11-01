//
//  BanciSettingCell.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/16.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanciModel.h"

@protocol BanciSettingDelegate <NSObject>

- (void)banciSetPushAction:(BanciModel *)model;

@end

@interface BanciSettingCell : UITableViewCell

/** 是否选中的按钮 */
@property (strong,nonatomic) UIButton *selectedBtn;
/** 班次名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 时间设定 */
@property (strong,nonatomic) UILabel *timeLabl;
/** 模型 */
@property (strong,nonatomic) BanciModel *model;

/** 代理 */
@property (weak,nonatomic) id<BanciSettingDelegate> delegate;

+ (instancetype)sharedBanciSettingCell:(UITableView *)tableView;


@end
