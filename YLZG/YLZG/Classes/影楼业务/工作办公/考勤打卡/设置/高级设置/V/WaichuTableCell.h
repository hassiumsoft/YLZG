//
//  WaichuTableCell.h
//  ChatDemo-UI3.0
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaichuTableCell : UITableViewCell

@property (strong,nonatomic) UILabel *label;

@property (strong,nonatomic) UILabel *infoLabel;

+ (instancetype)sharedWaichuCell:(UITableView *)tableView;

@end
