//
//  CheckWorkViewController.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SuperViewController.h"

typedef NS_ENUM(NSInteger,DakaStatus) {
    DakaClicked = 1, // 已经打卡
    UnDakaClicked = 0  // 没有打卡
};
typedef NS_ENUM(NSInteger,OnOffWorkType) {
    OnWorkType = 1,  // 上班
    OffWorkType = 2  // 下班
};


@interface CheckWorkViewController : SuperViewController

@end
