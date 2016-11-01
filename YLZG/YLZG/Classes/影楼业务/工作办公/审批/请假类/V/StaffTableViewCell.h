//
//  StaffTableViewCell.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/3/31.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffInfoModel.h"

@interface StaffTableViewCell : UITableViewCell

/** 员工头像 */
@property (strong,nonatomic) UIImageView *imageV;
/** 员工名称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 员工电话 */
@property (strong,nonatomic) UILabel *phoneLabel;
/** 距离员工生日 */
//@property (strong,nonatomic) UILabel *birthLabel;
/** birthImageV */
//@property (strong,nonatomic) UIImageView *birthImageV;
/** 我 */
@property (strong,nonatomic) UILabel *wo;
/** 店员模型 */
@property (strong,nonatomic) StaffInfoModel *model;
/** 初始化 */
+ (instancetype)sharedStaffTableViewCell:(UITableView *)tableView;

@end
