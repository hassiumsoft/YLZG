//
//  CalendarDayCell.m
//  tttttt
//
//  Created by 张凡 on 14-8-20.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarDayCell.h"
#import <Masonry.h>

@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = HWRandomColor;
        [self initView];
    }
    return self;
}

- (void)initView{
    
    //选中时显示的图片
    imgview = [[UIImageView alloc]initWithFrame:CGRectZero];
    imgview.layer.masksToBounds = YES;
    imgview.layer.cornerRadius = self.width/2;
    imgview.image = [UIImage imageWithColor:MainColor];
    [self addSubview:imgview];
    [imgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.height.equalTo(@(self.bounds.size.width));
    }];
    
    //日期
    day_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.bounds.size.width, self.bounds.size.width-10)];
    day_lab.textAlignment = NSTextAlignmentCenter;
    day_lab.font = [UIFont systemFontOfSize:15*CKproportion];
    [self addSubview:day_lab];
    [day_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_centerY);
        make.width.equalTo(@(self.width));
        make.height.equalTo(@21);
    }];

    //农历
    day_title = [[UILabel alloc]initWithFrame:CGRectZero];
    day_title.textColor = [UIColor grayColor];
    day_title.font = [UIFont boldSystemFontOfSize:12];
    day_title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:day_title];
    [day_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(day_lab.mas_bottom).offset(-4);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(self.width));
        make.height.equalTo(@21);
    }];
    
    //预约数量
    day_plan = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-15, self.bounds.size.width, 13)];
    day_plan.textColor = [UIColor redColor];
    day_plan.font = day_title.font;
    day_plan.textAlignment = NSTextAlignmentCenter;
    [self addSubview:day_plan];
    [day_plan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(self.width));
        make.top.equalTo(day_title.mas_bottom).offset(-6);
        make.height.equalTo(@21);
    }];

}


- (void)setModel:(CalendarDayModel *)model
{


    switch (model.style) {
        case CellDayTypeEmpty://不显示
            [self hidden_YES];
            break;
            
        case CellDayTypePast://过去的日期
            [self hidden_NO];
            
            if (model.holiday) {
                day_lab.text = model.holiday;
            }else{
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            }
            
            day_lab.textColor = [UIColor lightGrayColor];
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            day_plan.hidden = YES;
            break;
            
        case CellDayTypeFutur://将来的日期
            [self hidden_NO];
            
            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor orangeColor];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
                day_lab.textColor = MainColor;
            }
            day_plan.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.plan];
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            break;
            
        case CellDayTypeWeek://周末
            [self hidden_NO];
            
            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor orangeColor];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
                day_lab.textColor = MainColor;
            }
            day_plan.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.plan];
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            break;
            
        case CellDayTypeClick://被点击的日期
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            day_plan.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.plan];
            day_lab.textColor = [UIColor whiteColor];
            day_title.text = model.Chinese_calendar;
            imgview.hidden = NO;
            
            break;
            
        default:
            
            break;
    }

    if (model.plan < 0){
        day_plan.hidden = YES;
    }
}



- (void)hidden_YES{
    day_plan.hidden = YES;
    day_lab.hidden = YES;
    day_title.hidden = YES;
    imgview.hidden = YES;
    
}


- (void)hidden_NO{
    
    day_lab.hidden = NO;
    day_title.hidden = NO;
    day_plan.hidden = NO;
}


@end
