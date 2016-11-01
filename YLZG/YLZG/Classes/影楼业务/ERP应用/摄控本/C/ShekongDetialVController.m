//
//  ShekongDetialVController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/12.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ShekongDetialVController.h"
#import <MJExtension.h>
#import "NSDate+Extension.h"
#import <Masonry.h>
#import "UserInfoManager.h"

@interface ShekongDetialVController ()

@end

@implementation ShekongDetialVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSubViews];
}

- (void)setupSubViews
{
    NSDictionary *dict = [self.model mj_keyValues];
    KGLog(@"dict = %@",dict);
    
    // 修饰图+客户名称
    UILabel *guestLabel = [[UILabel alloc]init];
    guestLabel.text = self.model.guest;
    guestLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    guestLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:guestLabel];
    [guestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(20);
        make.height.equalTo(@21);
        make.top.equalTo(self.view.mas_top).offset(40*CKproportion);
    }];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    if ([self.model.type intValue] == 0) {
        imageV.image = [UIImage imageNamed:@"mywork_paizhao"];
    }else if ([self.model.type intValue] == 1) {
        imageV.image = [UIImage imageNamed:@"mywork_xuanpian"];
    }else if ([self.model.type intValue] == 2) {
        imageV.image = [UIImage imageNamed:@"mywork_kansheji"];
    }else if ([self.model.type intValue] == 3) {
        imageV.image = [UIImage imageNamed:@"mywork_qujian"];
    }else if ([self.model.type intValue] == 4) {
        imageV.image = [UIImage imageNamed:@"mywork_xiupian"];
    }else if ([self.model.type intValue] == 5) {
        imageV.image = [UIImage imageNamed:@"mywork_sheji"];
    }else if ([self.model.type intValue] == 6) {
        imageV.image = [UIImage imageNamed:@"mywork_qujian"];
    }
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(guestLabel.mas_left).offset(-8);
        make.width.and.height.equalTo(@40);
        make.centerY.equalTo(guestLabel.mas_centerY);
    }];
    
    UIImageView *xian1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self.view addSubview:xian1];
    [xian1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(18*CKproportion);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@1);
    }];
    
    // 价格
    UILabel *priceLabel = [[UILabel alloc]init];
    if ([self.model.set_price containsString:@"/"]) {
        NSRange range = [self.model.set_price localizedStandardRangeOfString:@"/"];
        NSString *price = [self.model.set_price substringWithRange:NSMakeRange(range.location + 1, self.model.set_price.length - range.location - 1)];
        priceLabel.text = [NSString stringWithFormat:@"￥%@",price];
    }else{
        priceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.set_price];
    }
    priceLabel.textColor = RGBACOLOR(247, 83, 34, 1);
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.font = [UIFont systemFontOfSize:28];
    [self.view addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(xian1.mas_bottom).offset(20*CKproportion);
        make.height.equalTo(@30);
    }];
    
    UIImageView *xian2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self.view addSubview:xian2];
    [xian2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel.mas_bottom).offset(18*CKproportion);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@3);
    }];
    
    // 套系名称
    UILabel *txLabel = [[UILabel alloc]init];
    txLabel.text = @"套系名称";
    txLabel.font = [UIFont systemFontOfSize:15];
    txLabel.textColor = [UIColor grayColor];
    [self.view addSubview:txLabel];
    [txLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.equalTo(@22);
        make.top.equalTo(xian2.mas_bottom).offset(15);
    }];
    
    UILabel *taoxiLabel = [[UILabel alloc]init];
    taoxiLabel.text = self.model.set_name;
    taoxiLabel.font = [UIFont systemFontOfSize:15];
    taoxiLabel.textColor = [UIColor blackColor];
    [self.view addSubview:taoxiLabel];
    [taoxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(txLabel.mas_right).offset(15);
        make.height.equalTo(@22);
        make.centerY.equalTo(txLabel.mas_centerY);
    }];
    
    // 联系方式
    UILabel *phLabel = [[UILabel alloc]init];
    phLabel.text = @"联系家长";
    phLabel.font = [UIFont systemFontOfSize:15];
    phLabel.textColor = [UIColor grayColor];
    [self.view addSubview:phLabel];
    [phLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.equalTo(@22);
        make.top.equalTo(txLabel.mas_bottom).offset(10);
    }];
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.textColor = [UIColor blackColor];
    [self.view addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phLabel.mas_right).offset(15);
        make.height.equalTo(@22);
        make.centerY.equalTo(phLabel.mas_centerY);
    }];
    
    UserInfoModel *userModel = [UserInfoManager getUserInfo];
    if ([userModel.vcip intValue] == 1) {
        phoneLabel.text = [NSString stringWithFormat:@"%@(点击拨打)",self.model.paphone];
        phoneLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            NSString *phoneNum = self.model.paphone;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            [self.view addSubview:webView];
        }];
        [phoneLabel addGestureRecognizer:tap];
    }else{
        phoneLabel.text = @"电话号码保密(您暂无权限，可求助管理员)";
    }
    
    
    
    // 分割线
    UIImageView *xian3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self.view addSubview:xian3];
    [xian3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@3);
    }];
    
    
    
    if ([self.model.type intValue] == 0) {
        // 拍照
        
        // 摄影师
        UILabel *syLabel = [UILabel new];
        syLabel.text = @"摄 影 师 ";
        syLabel.font = [UIFont systemFontOfSize:15];
        syLabel.textColor = [UIColor grayColor];
        [self.view addSubview:syLabel];
        [syLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15);
            make.height.equalTo(@22);
            make.top.equalTo(xian3.mas_bottom).offset(10);
        }];
        UILabel *sheyingerLabel = [[UILabel alloc]init];
        sheyingerLabel.text = self.model.pger;
        sheyingerLabel.font = [UIFont systemFontOfSize:15];
        sheyingerLabel.textColor = [UIColor blackColor];
        [self.view addSubview:sheyingerLabel];
        [sheyingerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(syLabel.mas_right).offset(15);
            make.height.equalTo(@22);
            make.centerY.equalTo(syLabel.mas_centerY);
        }];
        
        // 摄影助理
        UILabel *syzlLabel = [UILabel new];
        syzlLabel.text = @"摄影助理";
        syzlLabel.font = [UIFont systemFontOfSize:15];
        syzlLabel.textColor = [UIColor grayColor];
        [self.view addSubview:syzlLabel];
        [syzlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15);
            make.height.equalTo(@22);
            make.top.equalTo(syLabel.mas_bottom).offset(10);
        }];
        UILabel *syzlerLabel = [[UILabel alloc]init];
        syzlerLabel.text = self.model.pgassister;
        syzlerLabel.font = [UIFont systemFontOfSize:15];
        syzlerLabel.textColor = [UIColor blackColor];
        [self.view addSubview:syzlerLabel];
        [syzlerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(syzlLabel.mas_right).offset(15);
            make.height.equalTo(@22);
            make.centerY.equalTo(syzlLabel.mas_centerY);
        }];
        
        // 引导人
        UILabel *ydLabel = [UILabel new];
        ydLabel.text = @"引 导 人 ";
        ydLabel.font = [UIFont systemFontOfSize:15];
        ydLabel.textColor = [UIColor grayColor];
        [self.view addSubview:ydLabel];
        [ydLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15);
            make.height.equalTo(@22);
            make.top.equalTo(syzlLabel.mas_bottom).offset(10);
        }];
        UILabel *yderLabel = [[UILabel alloc]init];
        yderLabel.text = self.model.guide;
        yderLabel.font = [UIFont systemFontOfSize:15];
        yderLabel.textColor = [UIColor blackColor];
        [self.view addSubview:yderLabel];
        [yderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ydLabel.mas_right).offset(15);
            make.height.equalTo(@22);
            make.centerY.equalTo(ydLabel.mas_centerY);
        }];
        // 引导助理
        UILabel *ydzlLabel = [UILabel new];
        ydzlLabel.text = @"引导助理";
        ydzlLabel.font = [UIFont systemFontOfSize:15];
        ydzlLabel.textColor = [UIColor grayColor];
        [self.view addSubview:ydzlLabel];
        [ydzlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15);
            make.height.equalTo(@22);
            make.top.equalTo(ydLabel.mas_bottom).offset(10);
        }];
        UILabel *ydzlerLabel = [[UILabel alloc]init];
        ydzlerLabel.text = self.model.gassister;
        ydzlerLabel.font = [UIFont systemFontOfSize:15];
        ydzlerLabel.textColor = [UIColor blackColor];
        [self.view addSubview:ydzlerLabel];
        [ydzlerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ydzlLabel.mas_right).offset(15);
            make.height.equalTo(@22);
            make.centerY.equalTo(ydzlLabel.mas_centerY);
        }];
        
        // 景点信息
        UILabel *spotLabel = [UILabel new];
        spotLabel.text = @"景点信息";
        spotLabel.font = [UIFont systemFontOfSize:15];
        spotLabel.textColor = [UIColor grayColor];
        [self.view addSubview:spotLabel];
        [spotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15);
            make.height.equalTo(@22);
            make.top.equalTo(ydzlLabel.mas_bottom).offset(10);
        }];
        UILabel *vspotLabel = [[UILabel alloc]init];
        vspotLabel.text = self.model.vspot;
        vspotLabel.font = [UIFont systemFontOfSize:15];
        vspotLabel.textColor = [UIColor blackColor];
        [self.view addSubview:vspotLabel];
        [vspotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(spotLabel.mas_right).offset(15);
            make.height.equalTo(@22);
            make.centerY.equalTo(spotLabel.mas_centerY);
        }];
        
    }else if ([self.model.type intValue] == 1){
        // 选片
        UILabel *waitLabel = [[UILabel alloc]init];
        waitLabel.text = @"选片负责人";
        waitLabel.font = [UIFont systemFontOfSize:15];
        waitLabel.textColor = [UIColor grayColor];
        [self.view addSubview:waitLabel];
        [waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15);
            make.height.equalTo(@22);
            make.top.equalTo(xian3.mas_bottom).offset(10);
        }];
        
        UILabel *waitorLabel = [[UILabel alloc]init];
        waitorLabel.text = self.model.waitor;
        waitorLabel.font = [UIFont systemFontOfSize:15];
        waitorLabel.textColor = [UIColor blackColor];
        [self.view addSubview:waitorLabel];
        [waitorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(waitLabel.mas_right).offset(15);
            make.height.equalTo(@22);
            make.centerY.equalTo(waitLabel.mas_centerY);
        }];
        
    }else if ([self.model.type intValue] == 2){
        // 看样负责人
        UILabel *waitLabel = [[UILabel alloc]init];
        waitLabel.text = @"看样负责人";
        waitLabel.font = [UIFont systemFontOfSize:15];
        waitLabel.textColor = [UIColor grayColor];
        [self.view addSubview:waitLabel];
        [waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15);
            make.height.equalTo(@22);
            make.top.equalTo(xian3.mas_bottom).offset(10);
        }];
        
        UILabel *waitorLabel = [[UILabel alloc]init];
        waitorLabel.text = self.model.waitor;
        waitorLabel.font = [UIFont systemFontOfSize:15];
        waitorLabel.textColor = [UIColor blackColor];
        [self.view addSubview:waitorLabel];
        [waitorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(waitLabel.mas_right).offset(15);
            make.height.equalTo(@22);
            make.centerY.equalTo(waitLabel.mas_centerY);
        }];
    }else{
        // 取件
        
        // 取件人 waitor
        UILabel *kyLabel = [[UILabel alloc]init];
        kyLabel.text = @"取件负责人";
        kyLabel.font = [UIFont systemFontOfSize:15];
        kyLabel.textColor = [UIColor grayColor];
        [self.view addSubview:kyLabel];
        [kyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15);
            make.height.equalTo(@22);
            make.top.equalTo(xian3.mas_bottom).offset(10);
        }];
        
        UILabel *kanyangLabel = [[UILabel alloc]init];
        kanyangLabel.text = self.model.waitor;
        kanyangLabel.font = [UIFont systemFontOfSize:15];
        kanyangLabel.textColor = [UIColor blackColor];
        [self.view addSubview:kanyangLabel];
        [kanyangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kyLabel.mas_right).offset(15);
            make.height.equalTo(@22);
            make.centerY.equalTo(kyLabel.mas_centerY);
        }];
        
        // 门市人
        UILabel *msLabel = [[UILabel alloc]init];
        msLabel.text = @"门市店员";
        msLabel.font = [UIFont systemFontOfSize:15];
        msLabel.textColor = [UIColor grayColor];
        [self.view addSubview:msLabel];
        [msLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(15);
            make.height.equalTo(@22);
            make.top.equalTo(kanyangLabel.mas_bottom).offset(10);
        }];
        
        UILabel *menshiLabel = [[UILabel alloc]init];
        if (self.model.store.length >= 1) {
            menshiLabel.text = self.model.store;
        }else{
            menshiLabel.text = @"null(手机端预约)";
        }
        menshiLabel.font = [UIFont systemFontOfSize:15];
        menshiLabel.textColor = [UIColor blackColor];
        [self.view addSubview:menshiLabel];
        [menshiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(msLabel.mas_right).offset(15);
            make.height.equalTo(@22);
            make.centerY.equalTo(msLabel.mas_centerY);
        }];
        
        // 是否取件
        
        UILabel *isOKLabel = [[UILabel alloc]init];
        if (self.model.isok) {
            isOKLabel.text = @"制作完成";
            isOKLabel.backgroundColor = MainColor;
        }else{
            isOKLabel.text = @"暂未完成";
            isOKLabel.backgroundColor = RGBACOLOR(226, 67, 67, 1);
        }
        isOKLabel.textColor = [UIColor whiteColor];
        isOKLabel.font = [UIFont systemFontOfSize:20];
        isOKLabel.layer.masksToBounds = YES;
        isOKLabel.layer.cornerRadius = 50;
        isOKLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:isOKLabel];
        [isOKLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.and.height.equalTo(@100);
            make.top.equalTo(msLabel.mas_bottom).offset(40);
        }];
        
    }
    
    // 时间
    UILabel *dateLabel = [UILabel new];
    dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    dateLabel.textColor = RGBACOLOR(67, 67, 67, 1);
    dateLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo(@22);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
    
    UILabel *timeLabel = [UILabel new];
    if ([[UIDevice currentDevice].systemVersion intValue] >= 8.2) {
        timeLabel.font = [UIFont systemFontOfSize:17 weight:0.01];
    }else{
        timeLabel.font = [UIFont systemFontOfSize:17];
    }
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(dateLabel.mas_centerX);
        make.height.equalTo(@22);
        make.bottom.equalTo(dateLabel.mas_top);
    }];

    
    // 时分秒
    NSArray * timeArr = [self.model.time componentsSeparatedByString:@" "];
    NSString *dateStr = [timeArr firstObject];
    NSDate *firstDate = [self dateChanged:dateStr];
    
    BOOL isToday = [firstDate letuisToday];
    if (isToday) {
        dateLabel.text = @"今天";
    }else {
        NSString *lastTime = timeArr[0];
        if (lastTime.length >= 10) {
            lastTime = [lastTime stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
            dateLabel.text = [NSString stringWithFormat:@"%@日",lastTime];
            
        }else{
            dateLabel.text = lastTime;
        }
    }
    NSString *time = [timeArr lastObject];
    time = [time stringByReplacingOccurrencesOfString:@"-" withString:@":"];
    if (time.length < 5) {
        time = [NSString stringWithFormat:@"%@0",time];
    }
    timeLabel.text = time;
    
}


@end
