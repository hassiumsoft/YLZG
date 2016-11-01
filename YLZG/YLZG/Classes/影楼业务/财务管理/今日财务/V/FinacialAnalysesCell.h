//
//  FinacialAnalysesCell.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Huanzhuangbingtu.h"

@interface FinacialAnalysesCell : UITableViewCell

/** 最下面view */
@property (nonatomic, strong) UIView * bottomView;
/** 贝塞尔曲线 */
@property (nonatomic, strong) Huanzhuangbingtu * bingtuView;

@property (nonatomic, strong) UIImageView * imageV;
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UILabel * hhLabel;

/** 定金 */
@property (strong, nonatomic)UILabel * depositLabel;
/** 补款 */
@property (nonatomic, strong)UILabel * extraLabel;
/** 二次销售 */
@property (nonatomic, strong)UILabel * tsellLabel;
/** 其他 */
@property (nonatomic, strong)UILabel * otherLabel;

+ (instancetype)sharedFinacialAnalysesCell:(UITableView *)tableView;

@end
