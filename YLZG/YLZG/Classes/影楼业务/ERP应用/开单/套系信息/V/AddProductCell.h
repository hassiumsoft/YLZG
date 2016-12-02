//
//  AddProductCell.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/18.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllProductList.h"

@protocol AddProductCellDelegate <NSObject>

/** 添加产品的代理 */
- (void)addProduct:(AllProductList *)model;

@end

@interface AddProductCell : UITableViewCell

/** 产品名称 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 价格 */
@property (strong,nonatomic) UILabel *priceLabel;
/** 模型 */
@property (strong,nonatomic) AllProductList *model;
/** 代理 */
@property (weak,nonatomic) id<AddProductCellDelegate> delegate;

+ (instancetype)sharedAddProductCell:(UITableView *)tableView;

@end
