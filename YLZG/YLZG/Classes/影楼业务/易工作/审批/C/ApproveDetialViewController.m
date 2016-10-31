//
//  ApproveDetialViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/14.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ApproveDetialViewController.h"
#import <MJExtension.h>
#import "HTTPManager.h"
#import "ZCAccountTool.h"
#import "ShenpiSuggestController.h"
#import "ApproveDetialModel.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>


@interface ApproveDetialViewController ()

@property (strong,nonatomic) UIButton *agreeBtn;

@property (strong,nonatomic) UIButton *disagreeBtn;

/** 详细模型 */
@property (strong,nonatomic) ApproveDetialModel *detialModel;

@property (strong,nonatomic) UIScrollView *scrollView;
/** 状态描述 */
@property (strong,nonatomic) UILabel *statusL;
/** 审批中、已审核 */
@property (strong,nonatomic) UILabel *descLabel2;
/** 是否审核 */
@property (strong,nonatomic) UIImageView *isShenheImage;

/** 小球上面灰色的线 */
@property (nonatomic, strong) UILabel * grayLine;
/** 绿色的小球 */
@property (nonatomic, strong) UIImageView * greenImageV;
/** 第二个小球上面灰色的线 */
@property (nonatomic, strong) UILabel * grayLine1;
/** 第二个绿色的小球 */
@property (nonatomic, strong) UIImageView * greenImageV1;



@end

@implementation ApproveDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    [self getData];
    [YLNotificationCenter addObserver:self selector:@selector(reloadShenpiData:) name:YLReloadShenpiData object:nil];
}

- (void)reloadShenpiData:(NSNotification *)noti
{
    if (self.ReloadBlock) {
        _ReloadBlock();
    }
    NSString *option = noti.object;
    [self.isShenheImage setHidden:NO];
    if ([option isEqualToString:@"1"]) {
        self.isShenheImage.image = [UIImage imageNamed:@"shenhe_agree"];
        // 刷新数据
        _greenImageV1.image = [UIImage imageNamed:@"approve_hint"];
        self.descLabel2.text = @"审批完成";
        self.descLabel2.textColor = MainColor;
        [self.disagreeBtn removeFromSuperview];
        [self.agreeBtn removeFromSuperview];
    }else{
        self.isShenheImage.image = [UIImage imageNamed:@"shenhe_disagree"];
        // 刷新数据
        _greenImageV1.image = [UIImage imageNamed:@"approve_hint"];
        self.descLabel2.text = @"审批完成";
        self.descLabel2.textColor = RGBACOLOR(178, 34, 23, 1);
        [self.disagreeBtn removeFromSuperview];
        [self.agreeBtn removeFromSuperview];
    }
}

- (void)getData
{
    ZCAccount *account = [ZCAccountTool account];
    [self showHudMessage:@"加载中···"];
    NSString *url = [NSString stringWithFormat:ShenpiWaitDeatil_URL,self.model.id,self.model.kind,account.userID];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        int status = [[[responseObject objectForKey:@"code"] description] intValue];
        
        [self hideHud:0];
        if (status == 1) {
            
            NSDictionary *dicionary = [responseObject objectForKey:@"result"];
            KGLog(@"dicionary = %@",dicionary);
            self.detialModel = [ApproveDetialModel mj_objectWithKeyValues:dicionary];
            
            [self setupSubViews];
        }else{
            [self sendErrorWarning:@"获取信息失败"];
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}

/**
 "appro_nickname" = "\U6d4b\U8bd5\U7ba1\U7406\U5458";
 "appro_opinion" = "";
 "appro_time" = 0;
 approver = 1;
 finish = 0;
 "how_long" = "3\U5c0f\U65f6";
 id = 8;
 image = "<null>";
 kind = 3;
 reason = "\U5c31\U662f\U54e6\U4f60\U5c31\U53ef\U4ee5";
 sid = 1;
 "sply_nickname" = "\U5927\U9e4f";
 "sply_time" = 1462957800;
 start = 0;
 status = 0;
 uid = 3;
 */

- (void)setupSubViews
{
    // 上面的视图
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.backgroundColor = self.view.backgroundColor;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.scrollView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.userInteractionEnabled = YES;
    [self.scrollView addSubview:topView];
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[self imageWithBgColor:HWRandomColor]];
    [topView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(6);
        make.top.equalTo(topView.mas_top).offset(20);
        make.width.and.height.equalTo(@50);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(10);
        make.top.equalTo(imageV.mas_top).offset(4);
        make.height.equalTo(@21);
    }];
    
    
    
    
    self.statusL = [[UILabel alloc]init];
    if (self.model.status) {
        // 已审批
        self.statusL.text = [NSString stringWithFormat:@"%@已审批",self.model.appro_nickname];
    }else{
        // 等待审批
        self.statusL.text = [NSString stringWithFormat:@"等待%@审批",self.model.appro_nickname];
    }
    self.statusL.textColor = [UIColor grayColor];
    self.statusL.font = [UIFont systemFontOfSize:14];
    [topView addSubview:self.statusL];
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left);
        make.top.equalTo(titleLabel.mas_bottom).offset(6);
        make.height.equalTo(@21);
    }];
    
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [topView addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left);
        make.right.equalTo(topView.mas_right);
        make.height.equalTo(@2);
        make.top.equalTo(imageV.mas_bottom).offset(5);
    }];
    
    UILabel *typeLabel = [[UILabel alloc]init];
    typeLabel.text = @"请假类型：病假";
    typeLabel.textColor = [UIColor grayColor];
    typeLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(12);
        make.height.equalTo(@21);
        make.top.equalTo(xian.mas_bottom).offset(3);
    }];
    
    UILabel *startTime = [[UILabel alloc]init];
    NSString *time = [self TimeIntToDateStr:self.detialModel.sply_time];
    startTime.text = [NSString stringWithFormat:@"申请时间：%@",time];
    startTime.textColor = [UIColor grayColor];
    startTime.font = [UIFont systemFontOfSize:14];
    [topView addSubview:startTime];
    [startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(12);
        make.top.equalTo(typeLabel.mas_bottom);
        make.height.equalTo(@21);
    }];
    
    UILabel *realsonLabel = [[UILabel alloc]init];
    realsonLabel.text = @"请假事由：感冒";
    realsonLabel.textColor = [UIColor grayColor];
    realsonLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:realsonLabel];
    [realsonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startTime.mas_left);
        make.top.equalTo(startTime.mas_bottom);
        make.height.equalTo(@21);
    }];
    
    self.isShenheImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shenhe_agree"]];
    [topView addSubview:_isShenheImage];
    [_isShenheImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-15);
        make.top.equalTo(topView.mas_top).offset(79);
        make.width.and.height.equalTo(@85);
    }];
    
    
    /************** 下面的2个过程  *****************/
    UIView *startImag = [[UIView alloc]init];
    startImag.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:startImag];
    [startImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-18);
        make.top.equalTo(topView.mas_top).offset(220);
        make.height.equalTo(@64);
        make.left.equalTo(self.view.mas_left).offset(64);
    }];
    
    UIImageView *headV1 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 9, 40, 40)];
    NSString *head = [NSString stringWithFormat:@"%@",self.model.sply_head];
    [headV1 sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    headV1.backgroundColor = [UIColor clearColor];
    headV1.layer.masksToBounds = YES;
    headV1.layer.cornerRadius = 20;
    [startImag addSubview:headV1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headV1.frame) + 10, 9, 100, 22)];
    label1.text = self.detialModel.sply_nickname;
    label1.font = [UIFont systemFontOfSize:15];
    [startImag addSubview:label1];
    
    UILabel *descLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headV1.frame) + 10, CGRectGetMaxY(label1.frame), 100, 21)];
    descLabel1.text = @"发起审批";
    descLabel1.textColor = RGBACOLOR(49, 164, 37, 1);
    descLabel1.font = [UIFont systemFontOfSize:15];
    [startImag addSubview:descLabel1];
    
    /** 第一个绿色的小球 */
    _grayLine = [self getGrayLineFrame:CGRectMake(40, CGRectGetMaxY(topView.frame), 1, 25)];
    _greenImageV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_grayLine.frame)-11, CGRectGetMaxY(_grayLine.frame), 22, 22)];
    _greenImageV.image = [UIImage imageNamed:@"approve_hint"];
    [self.view addSubview:_greenImageV];
    /** 第二个绿色的小球 */
    _grayLine1 = [self getGrayLineFrame:CGRectMake(CGRectGetMinX(_grayLine.frame), CGRectGetMaxY(_greenImageV.frame), 1, 55)];
    _greenImageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_grayLine1.frame)-11, CGRectGetMaxY(_grayLine1.frame), 22, 22)];
    [self.view addSubview:_greenImageV1];
    
    UIView *endImag = [[UIView alloc]init];
    endImag.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:endImag];
    [endImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-18);
        make.top.equalTo(topView.mas_top).offset(220 + 64 + 25);
        make.height.equalTo(@64);
        make.left.equalTo(self.view.mas_left).offset(64);
    }];
    
    UIImageView *headV2 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 9, 40, 40)];
    [headV2 sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    headV2.backgroundColor = [UIColor clearColor];
    headV2.layer.masksToBounds = YES;
    headV2.layer.cornerRadius = 20;
    [endImag addSubview:headV2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headV1.frame) + 10, 9, 100, 22)];
    label2.text = self.detialModel.sply_nickname;
    label2.font = [UIFont systemFontOfSize:15];
    [endImag addSubview:label2];
    
    self.descLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headV2.frame) + 10, CGRectGetMaxY(label2.frame), 200, 21)];
    self.descLabel2.text = @"已审批";
    self.descLabel2.textColor = [UIColor orangeColor];
    self.descLabel2.font = [UIFont systemFontOfSize:15];
    [endImag addSubview:self.descLabel2];
    
    
    
    switch (self.model.kind) {
        case 1:
        {
            // 通用审批
            imageV.image = [UIImage imageNamed:@"wait_tongyong"];
            titleLabel.text = [NSString stringWithFormat:@"%@的其他审批",self.model.sply_nickname];
            typeLabel.text = [NSString stringWithFormat:@"申请内容：%@",self.detialModel.title];
            realsonLabel.text = [NSString stringWithFormat:@"理由：%@",self.detialModel.content];
            
            
            break;
        }
        case 2:
        {
            // 请假
            imageV.image = [UIImage imageNamed:@"wait_qingjia"];
            
            titleLabel.text = [NSString stringWithFormat:@"%@的请假申请",self.model.sply_nickname];
            typeLabel.text = [NSString stringWithFormat:@"申请类型：%@",self.detialModel.type];
            realsonLabel.text = [NSString stringWithFormat:@"理由：%@",self.detialModel.reason];
            break;
        }
        case 3:
        {
            // 外出
            imageV.image = [UIImage imageNamed:@"wait_out"];
            titleLabel.text = [NSString stringWithFormat:@"%@的外出审批",self.model.sply_nickname];
            NSString *start = [self TimeIntToDateStr:self.detialModel.start];
            NSString *finish = [self TimeIntToDateStr:self.detialModel.finish];
            if (start.length >= 10) {
                start = [start substringWithRange:NSMakeRange(0, 10)];
            }
            if (finish.length >= 10) {
                finish = [finish substringWithRange:NSMakeRange(0, 10)];
            }
            typeLabel.text = [NSString stringWithFormat:@"外出时间:%@-%@",start,finish];
            realsonLabel.text = [NSString stringWithFormat:@"理由：%@",self.detialModel.reason];
            
            break;
        }
        case 4:
        {
            // 物品领用
            imageV.image = [UIImage imageNamed:@"wait_shiwu"];
            titleLabel.text = [NSString stringWithFormat:@"%@的物品领用通知",self.model.sply_nickname];
            typeLabel.text = [NSString stringWithFormat:@"物品信息：%ld个用于'%@的'%@",(long)self.detialModel.nums,self.detialModel.usages,self.detialModel.items];
            realsonLabel.text = [NSString stringWithFormat:@"备注：%@",self.detialModel.details];
            
            
            break;
        }
        default:
            break;
    }
    
    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.detialModel.sply_head]] placeholderImage:[UIImage imageNamed:@"user_place"]];
    
    if (self.detialModel.status == 1) {
        // 已审核通过的
        self.descLabel2.text = [NSString stringWithFormat:@"已通过审核"];
        self.descLabel2.textColor = RGBACOLOR(43, 171, 63, 1);
        
        _greenImageV1.image = [UIImage imageNamed:@"approve_hint"];
        
        
        
    }else if(self.detialModel.status == 0){
        // 等待审核的
        [self.isShenheImage setHidden:YES];
        
        self.descLabel2.text = @"等待审批";
        self.descLabel2.textColor = RGBACOLOR(251, 168, 41, 1);
        
        _greenImageV1.image = [UIImage imageNamed:@"UnApprove"];
        
        
        if (self.isMe) {
            // 是我发起的申请。不显示同意拒绝按钮
            
        }else{
            // 同意/拒绝按钮
            self.agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
            self.agreeBtn.backgroundColor = RGBACOLOR(49, 164, 37, 1);
            self.agreeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [self.agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.agreeBtn];
            [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left);
                make.bottom.equalTo(self.view.mas_bottom);
                make.width.equalTo(@(SCREEN_WIDTH/2));
                make.height.equalTo(@44);
            }];
            
            self.disagreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.disagreeBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            self.disagreeBtn.backgroundColor = RGBACOLOR(226, 38, 38, 1);
            self.disagreeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [self.disagreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.disagreeBtn addTarget:self action:@selector(disagreeAction) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.disagreeBtn];
            [self.disagreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view.mas_right);
                make.bottom.equalTo(self.view.mas_bottom);
                make.width.equalTo(@(SCREEN_WIDTH/2));
                make.height.equalTo(@44);
            }];
        }
        
    }else if (self.detialModel.status == 2){
        // 申请被拒绝
        
        self.descLabel2.text = [NSString stringWithFormat:@"申请被拒绝"];
        self.descLabel2.textColor = [UIColor redColor];
        
        _greenImageV1.image = [UIImage imageNamed:@"approve_hint"];
        _isShenheImage.image = [UIImage imageNamed:@"shenhe_disagree"];
        
    }
    
    if (self.haveShenpi) {
        // 已经审批，不显示按钮
        [self.agreeBtn removeFromSuperview];
        [self.disagreeBtn removeFromSuperview];
    }
    
    if (self.detialModel.status != 0) {
        
        // 第三个小绿球
        UIImageView *greenV3 = [[UIImageView alloc] init];
        greenV3.image = [UIImage imageNamed:@"approve_hint"];
        [self.view addSubview:greenV3];
        [greenV3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).offset(-25);
            make.top.equalTo(endImag.mas_bottom).offset(40);
            make.width.and.height.equalTo(@24);
        }];
        
        // 添加一行审核人信息
        UIView *shenherView = [[UIView alloc]initWithFrame:CGRectZero];
        shenherView.backgroundColor = [UIColor whiteColor];
        shenherView.userInteractionEnabled = YES;
        [self.view addSubview:shenherView];
        [shenherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.greenImageV1.mas_left);
            make.centerY.equalTo(greenV3.mas_centerY);
            make.right.equalTo(greenV3.mas_left).offset(-12);
            make.height.equalTo(@60);
        }];
        
        UIImageView *shenpiImageV = [[UIImageView alloc]init];
        [shenpiImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.detialModel.appro_head]] placeholderImage:[UIImage imageNamed:@"user_place"]];
        [shenherView addSubview:shenpiImageV];
        [shenpiImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(shenherView.mas_right).offset(-5);
            make.centerY.equalTo(shenherView.mas_centerY);
            make.width.and.height.equalTo(@40);
        }];
        
        UILabel *approvLabel = [[UILabel alloc]init];
        approvLabel.text = self.detialModel.appro_nickname;
        approvLabel.textAlignment = NSTextAlignmentRight;
        approvLabel.font = [UIFont systemFontOfSize:14];
        [shenherView addSubview:approvLabel];
        [approvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(shenpiImageV.mas_left).offset(-5);
            make.height.equalTo(@21);
            make.width.equalTo(@100);
            make.bottom.equalTo(shenpiImageV.mas_centerY);
        }];
        
        UILabel *approver = [[UILabel alloc]init];
        approver.text = self.detialModel.appro_opinion;
        approver.textAlignment = NSTextAlignmentRight;
        approver.font = [UIFont systemFontOfSize:14];
        [shenherView addSubview:approver];
        [approver mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(shenpiImageV.mas_left).offset(-5);
            make.height.equalTo(@21);
            make.width.equalTo(@100);
            make.top.equalTo(shenpiImageV.mas_centerY);
        }];
        
        if (self.detialModel.status == 1) {
            approver.textColor = MainColor;
            
        }else{
            approver.textColor = [UIColor redColor];
        }
        
    }
    
    
}

//#pragma mark - 时间戳转化
//- (NSString *)timeChanged:(NSTimeInterval)timeChuo
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeChuo];
//    NSString *origanStr = [NSString stringWithFormat:@"%@",date];
//    if (origanStr.length >= 16) {
//        NSString *time = [origanStr substringWithRange:NSMakeRange(0, 16)];
//        return time;
//    }else{
//        return origanStr;
//    }
//}

- (void)agreeAction
{
    ShenpiSuggestController *suggest = [[ShenpiSuggestController alloc]init];
    suggest.isAgree = YES;
    suggest.model = self.model;
    [self.navigationController pushViewController:suggest animated:YES];
}
- (void)disagreeAction
{
    ShenpiSuggestController *suggest = [[ShenpiSuggestController alloc]init];
    suggest.isAgree = NO;
    suggest.model = self.model;
    [self.navigationController pushViewController:suggest animated:YES];
}


#pragma mark -绿色小球上的灰色的线
- (UILabel *)getGrayLineFrame:(CGRect)frame {
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = RGBACOLOR(196, 196, 196, 1);
    [self.view addSubview:label];
    return label;
}


@end
