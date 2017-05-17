//
//  FromUserTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 2017/5/17.
//  Copyright © 2017年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FromUserTableCell : UITableViewCell

@property (strong,nonatomic) VersionInfoModel *versionModel;

+ (instancetype)sharedUserCell:(UITableView *)tableView;

@end
