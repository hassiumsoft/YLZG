//
//  DetailHeadView.m
//  YLZG
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "DetailHeadView.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface DetailHeadView ()

@property (strong,nonatomic) UIImageView *imageV;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UILabel *lognumLabel;

@end

@implementation DetailHeadView

- (void)setModel:(ContactersModel *)model
{
    _model = model;
    if ([model.gender intValue] == 1) {
     [_imageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
    }else{
        [_imageV sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
    }
    _nameLabel.text = model.realname.length >= 1 ? model.realname : model.nickname;;
    _lognumLabel.text = [NSString stringWithFormat:@"影楼ID：%@",model.name];
}

-(instancetype)initWithFrame:(CGRect)frame{
   self =  [super initWithFrame:frame];
    if(self){
        
        _imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_gg_mrtouxiang"]];
        _imageV.layer.masksToBounds = YES;
        _imageV.layer.cornerRadius = 4;
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageV];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"火星人";
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nameLabel];
        
        
        _lognumLabel = [[UILabel alloc] init];
        _lognumLabel.text = [NSString stringWithFormat:@"影楼ID：···"];
       _lognumLabel.textColor = [UIColor grayColor];
       _lognumLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
       _lognumLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lognumLabel];
        _lognumLabel.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapGues)];
        tap.numberOfTapsRequired = 1;
        [_lognumLabel addGestureRecognizer:tap];
        
    }
    return self;
}

#pragma mark - 长按复制ID
- (void)longTapGues
{
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    menu.menuVisible = YES;
    UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(pasted)];
    menu.menuItems = @[menuItem];
    menu.arrowDirection = UIMenuControllerArrowDown;
    [menu setTargetRect:SCREEN_BOUNDS inView:self];
    
    
}
- (void)pasted
{
    
}
-(void)layoutSubviews {
    [super layoutSubviews];
    _imageV.frame = CGRectMake(20, 18, 70, 70);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_imageV.frame) + 8, 23, 120, 22);
    _lognumLabel.frame = CGRectMake(CGRectGetMaxX(_imageV.frame) + 8, 23 + 25, 200, 22);
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return YES;
}
+ (instancetype)detailHeadView{
    
    return [[self alloc] init];
}

@end
