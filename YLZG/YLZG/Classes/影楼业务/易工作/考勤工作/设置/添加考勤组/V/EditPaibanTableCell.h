//
//  EditPaibanTableCell.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/13.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GudingPaibanModel.h"


@protocol EditPaibanTableCellDelegate <NSObject>

- (void)editPaibanCellWithModel:(GudingPaibanModel *)model;

@end

/********* 编辑排班 ***********/

@interface EditPaibanTableCell : UITableViewCell
/** 选中按钮 */
@property (strong,nonatomic) UIButton *selectedBtn;
/** 周几 */
@property (strong,nonatomic) UILabel *weekLabel;
/** 班次名称 */
@property (strong,nonatomic) UILabel *banciNameLabel;
/** 时间：上班-下班 */
@property (strong,nonatomic) UILabel *timeLabel;
/** 代理 */
@property (weak,nonatomic) id<EditPaibanTableCellDelegate> delegate;

@property (strong,nonatomic) GudingPaibanModel *model;

+ (instancetype)sharedEditPaibanTableCell:(UITableView *)tableView;

@end
