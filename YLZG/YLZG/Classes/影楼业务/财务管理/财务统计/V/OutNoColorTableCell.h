//
//  OutNoColorTableCell.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/5.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutComeModel.h"

@interface OutNoColorTableCell : UITableViewCell

@property (strong,nonatomic) OutComeModel *outModel;

+ (instancetype)sharedOutNoColorTableCell:(UITableView *)tableView;

@end
