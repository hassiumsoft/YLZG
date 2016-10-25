//
//  EditProductCell.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/17.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoxiProductModel.h"



typedef void (^modelBlock)(TaoxiProductModel *model);



@interface EditProductCell : UITableViewCell
/** 标题 */
@property (strong,nonatomic) UILabel *titleLabel;
/** 价格 */
@property (strong,nonatomic) UILabel *priceLabel;
/** 加急时间 */
@property (strong,nonatomic) UILabel *jiajiLabel;
/** 是否加急的图片 */
@property (strong,nonatomic) UIImageView *jiajiImageV;
/** 套系产品模型 */
@property (strong,nonatomic) TaoxiProductModel *model;

/** block作为@property */
@property (copy,nonatomic) modelBlock block;


/** 初始化 */
+ (instancetype)sharedEditProductCell:(UITableView *)tableView;

@end
