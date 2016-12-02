//
//  ProduceDetialFileCell.h
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProduceFileModel.h"

@interface ProduceDetialFileCell : UITableViewCell

@property (strong,nonatomic) ProduceFileModel *fileModel;

@property (copy,nonatomic) void (^DidBlock)(NSInteger fileType);

+ (instancetype)sharedProduceDetialFileCell:(UITableView *)tableView;

@end
