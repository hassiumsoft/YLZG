//
//  AppearHeadView.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/31.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "AppearHeadView.h"
#import "AppearView.h"


@interface AppearHeadView ()

@property (strong,nonatomic) AppearView *appearView1;

@property (strong,nonatomic) AppearView *appearView2;

@property (strong,nonatomic) AppearView *appearView3;


@end


#define Height 150

@implementation AppearHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setupSubViews];
    }
    return self;
}


- (void)setWaitArray:(NSArray *)waitArray
{
    _waitArray = waitArray;
    _appearView1.numLabel.text = [NSString stringWithFormat:@"%d",(int)waitArray.count];
}
- (void)setAppredArr:(NSMutableArray *)appredArr
{
    _appredArr = appredArr;
    _appearView2.numLabel.text = [NSString stringWithFormat:@"%d",(int)appredArr.count];
}
- (void)setMyApplyArr:(NSMutableArray *)myApplyArr
{
    _myApplyArr = myApplyArr;
    _appearView3.numLabel.text = [NSString stringWithFormat:@"%d",(int)myApplyArr.count];
}

- (void)setupSubViews
{
    UIImageView *topImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_bg"]];
    topImageV.frame = CGRectMake(0, 0, SCREEN_WIDTH, Height);
    [self addSubview:topImageV];
    
    // 添加view
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, Height, SCREEN_WIDTH, self.height-Height)];
    middleView.userInteractionEnabled = YES;
    [self addSubview:middleView];
    
    NSArray *titleArr = @[@"待我审批",@"我已审批",@"我发起的"];
    for (int i = 0; i < titleArr.count; i++) {
        CGRect frame;
        frame.origin.x = SCREEN_WIDTH/3 * i;
        frame.origin.y = Height;
        frame.size.width = SCREEN_WIDTH/3;
        frame.size.height = self.height - Height;
        
        if (i == 0) {
            self.appearView1 = [[AppearView alloc]initWithFrame:frame];
            self.appearView1.tag = 10+i;
            self.appearView1.titleLabel.text = titleArr[i];
            [self addSubview:self.appearView1];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ButtonClick:)];
            [self.appearView1 addGestureRecognizer:tap];
        } else if(i == 1){
            self.appearView2 = [[AppearView alloc]initWithFrame:frame];
            self.appearView2.tag = 10+i;
            self.appearView2.titleLabel.text = titleArr[i];
            [self addSubview:self.appearView2];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ButtonClick:)];
            [self.appearView2 addGestureRecognizer:tap];
        }else{
            self.appearView3 = [[AppearView alloc]initWithFrame:frame];
            self.appearView3.tag = 10+i;
            self.appearView3.titleLabel.text = titleArr[i];
            [self addSubview:self.appearView3];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ButtonClick:)];
            [self.appearView3 addGestureRecognizer:tap];
        }
        
    }
    
}

- (void)ButtonClick:(UITapGestureRecognizer *)tap
{
    AppearView *view = (AppearView *)tap.view;
    
    if (_ClickBlock) {
        _ClickBlock(view.tag);
    }
}

@end
