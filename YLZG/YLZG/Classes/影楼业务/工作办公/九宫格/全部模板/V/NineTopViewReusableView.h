//
//  NineTopViewReusableView.h
//  YLZG
//
//  Created by Chan_Sir on 2016/12/2.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 推荐模板 */

@interface NineTopViewReusableView : UICollectionReusableView

@property (copy,nonatomic) void (^DidClickBlock)();

/** 标签数组 */
@property (copy,nonatomic) NSArray *titleArray;

@end
