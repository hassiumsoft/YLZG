//
//  EditProductCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/1.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoxiProductModel.h"


typedef void (^JiajiBlock)(TaoxiProductModel *model);

@interface EditProductCell : UITableViewCell

/** 套系产品模型 */
@property (strong,nonatomic) TaoxiProductModel *model;

/** block作为@property */
@property (copy,nonatomic) JiajiBlock block;

/** 初始化 */
+ (instancetype)sharedEditProductCell:(UITableView *)tableView;

@end
