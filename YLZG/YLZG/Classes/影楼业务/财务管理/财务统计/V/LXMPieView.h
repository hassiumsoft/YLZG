//
//  LXMPieView.h
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/29.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXMPieView;

@protocol LXMPieViewDelegate <NSObject>

- (void)lxmPieView:(LXMPieView *)pieView didSelectSectionAtIndex:(NSInteger)index;

@end


@interface LXMPieModel : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, copy) NSString *text;

- (instancetype)initWithColor:(UIColor *)color value:(CGFloat)value text:(NSString *)text;

@end



@interface LXMPieView : UIView

@property (nonatomic, weak) id<LXMPieViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame values:(NSArray<LXMPieModel *> *)valueArray;

- (void)reloadData;

@end
