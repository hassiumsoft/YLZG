//
//  NineTopViewReusableView.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/2.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NineCategoryModel.h"

/** 推荐模板 */

@interface NineTopViewReusableView : UICollectionReusableView

/** 点击热门/推荐模板的回调 */
@property (copy,nonatomic) void (^DidClickBlock)();
/** 点击模板标签的回调 */
@property (copy,nonatomic) void (^CategoryClick)(NineCategoryModel *cateModel);

/** 标签数组 */
@property (copy,nonatomic) NSArray *titleArray;

@end
