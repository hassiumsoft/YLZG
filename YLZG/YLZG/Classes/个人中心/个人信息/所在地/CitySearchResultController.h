//
//  CitySearchResultController.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/5/26.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "SuperTableViewController.h"

/*********** 城市搜索结果 ***********/

@interface CitySearchResultController : SuperTableViewController

/** 搜索关键字 */
@property (copy,nonatomic) NSString *searchText;

@property (copy,nonatomic) void (^DidSelectCity)();

@end
