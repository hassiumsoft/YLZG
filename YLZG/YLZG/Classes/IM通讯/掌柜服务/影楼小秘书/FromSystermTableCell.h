//
//  FromSystermTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/16.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FromSystermTableCell : UITableViewCell

@property (strong,nonatomic) VersionInfoModel *versionModel;

+ (instancetype)sharedSystermCell:(UITableView *)tableView;

@end
