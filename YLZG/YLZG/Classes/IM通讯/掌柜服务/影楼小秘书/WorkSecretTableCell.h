//
//  WorkSecretTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/15.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VersionInfoModel.h"

/** 公告消息 */
@interface WorkSecretTableCell : UITableViewCell
/** 版本信息 */
@property (strong,nonatomic) VersionInfoModel *versionModel;
/** 初始化 */
+ (instancetype)sharedWorkCell:(UITableView *)tableView;

@end
