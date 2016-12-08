//
//  EditCareTableViewCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NineCategoryModel.h"

@interface EditCareTableViewCell : UITableViewCell

@property (strong,nonatomic) NineCategoryModel *cateModel;

+ (instancetype)sharedEditCareCell:(UITableView *)tableView;

@end
