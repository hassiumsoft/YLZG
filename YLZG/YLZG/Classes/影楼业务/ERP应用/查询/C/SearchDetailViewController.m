//
//  SearchDetailViewController.m
//  YLZG
//
//  Created by Chan_Sir on 2016/10/10.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "ZCAccountTool.h"
#import "NSString+StrCategory.h"
#import "HTTPManager.h"

@interface SearchDetailViewController ()

// 数据源
@property (nonatomic, strong)NSMutableDictionary * dict;
// 底层的ScrollView
@property (nonatomic, strong) UIScrollView * backScrollView;
// 订单号栏目
@property (nonatomic, strong) UIView * orderView;
// 订单进度
@property (nonatomic, strong) UIView * progressView;
// 客户信息
@property (nonatomic, strong) UIView * guestInfo;
// 套系名称
@property (nonatomic, strong) UIView * pakageView;
// 付款信息
@property (nonatomic, strong) UIView * payView;
// 是否取件
@property (nonatomic, strong) UIView * takeView;
//电话号码
@property (nonatomic, strong) NSArray * guestInfoTitle;

@end

@implementation SearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    // 初始化
    [self selfInitSearchDetailViewControllerVC];
    // 请求数据
    [self loadSearchDetailViewControllerData];
    
}

#pragma mark - 初始化
- (void)selfInitSearchDetailViewControllerVC{
    self.title = @"订单详情";
    _dict = [[NSMutableDictionary alloc]init];
    /**
     因为请求数据时间的原因,必须放在这
     */
    // 创建底部的ScrollView
    self.backScrollView = [[UIScrollView alloc] initWithFrame:SCREEN_BOUNDS];
    self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 98);
    self.backScrollView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.backScrollView];
    // 创建头部的订单栏目
    self.orderView = [self getViewFrame:CGRectMake(0, 5, SCREEN_WIDTH, 44)];
    self.orderView.userInteractionEnabled = YES;
    // 创建订单进度栏目
    self.progressView = [self getViewFrame:CGRectMake(0, CGRectGetMaxY(_orderView.frame)+10, SCREEN_WIDTH, 44*3)];
    //创建订单进度的label
    UILabel * progressLabel = [self getLabelFrame:CGRectMake(10, 11, SCREEN_WIDTH, 20) andText:@"订单进度" andFont:[UIFont systemFontOfSize:15] andTextColor:[UIColor colorWithWhite:0.293 alpha:1.000]];
    [self.progressView addSubview:progressLabel];
    UILabel * progressLine = [self getLabelFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1) andText:nil andFont:nil andTextColor:nil];
    progressLine.backgroundColor = [UIColor colorWithRed:0.910 green:0.906 blue:0.914 alpha:1.000];
    [self.progressView addSubview:progressLine];
    
    NSArray * prgressTitle = @[@"拍照", @"修片", @"选片", @"精修", @"设计", @"看设计"];
    for (int i = 0 ; i < 6; i++) {
        UILabel * label = [self getLabelFrame:CGRectMake(15 + (SCREEN_WIDTH-30)/6*i, 44+11, (SCREEN_WIDTH-30)/6, 20) andText:prgressTitle[i] andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor colorWithWhite:0.475 alpha:1.000]];
        [self.progressView addSubview:label];
    }
    // 创建客户信息
    self.guestInfo = [self getViewFrame:CGRectMake(0, CGRectGetMaxY(_progressView.frame)+10, SCREEN_WIDTH, 44*3+10)];
    UILabel * guestInfoLabel = [self getLabelFrame:CGRectMake(10, 11, SCREEN_WIDTH, 20) andText:@"客户信息" andFont:[UIFont systemFontOfSize:15] andTextColor:[UIColor colorWithWhite:0.293 alpha:1.000]];
    [self.guestInfo addSubview:guestInfoLabel];
    UILabel * guestInfoLine = [self getLabelFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1) andText:nil andFont:nil andTextColor:nil];
    guestInfoLine.backgroundColor = [UIColor colorWithRed:0.910 green:0.906 blue:0.914 alpha:1.000];
    [self.guestInfo addSubview:guestInfoLine];
    
    // 套系名称
    self.pakageView = [self getViewFrame:CGRectMake(0, CGRectGetMaxY(_guestInfo.frame)+10, SCREEN_WIDTH, 44)];
    // 套系名称的label
    UILabel * pakageLabel = [self getLabelFrame:CGRectMake(10, 11, 200, 20) andText:@"套系名称" andFont:[UIFont systemFontOfSize:15] andTextColor:[UIColor colorWithWhite:0.293 alpha:1.000]];
    [self.pakageView addSubview:pakageLabel];
    
    // 付款信息栏目
    self.payView = [self getViewFrame:CGRectMake(0, CGRectGetMaxY(_pakageView.frame)+10, SCREEN_WIDTH, 44*3)];
    UILabel * payLabel = [self getLabelFrame:CGRectMake(10, 11, SCREEN_WIDTH, 20) andText:@"付款信息" andFont:[UIFont systemFontOfSize:15] andTextColor:[UIColor colorWithWhite:0.293 alpha:1.000]];
    [self.payView addSubview:payLabel];
    UILabel * payLine = [self getLabelFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1) andText:nil andFont:nil andTextColor:nil];
    payLine.backgroundColor = [UIColor colorWithRed:0.910 green:0.906 blue:0.914 alpha:1.000];
    [self.payView addSubview:payLine];
    
    // 付款信息
    NSArray * payTitle = @[@"总价", @"已付款", @"欠款"];
    for (int i = 0; i < 3; i++) {
        UILabel * label = [self getLabelFrame:CGRectMake(SCREEN_WIDTH/3 * i, 44+11, SCREEN_WIDTH/3, 20) andText:payTitle[i] andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor colorWithWhite:0.475 alpha:1.000]];
        label.textAlignment = NSTextAlignmentCenter;
        [self.payView addSubview:label];
    }
    // 是否取件
    self.takeView = [self getViewFrame:CGRectMake(0, CGRectGetMaxY(_payView.frame)+10, SCREEN_WIDTH, 44)];
    UILabel * takeLabel = [self getLabelFrame:CGRectMake(10, 11, 200, 20) andText:@"是否取件" andFont:[UIFont systemFontOfSize:15] andTextColor:[UIColor colorWithWhite:0.475 alpha:1.000]];
    [self.takeView addSubview:takeLabel];
}


#pragma mark - 请求数据
- (void)loadSearchDetailViewControllerData{
    
    // 取出登录成功的uid
    ZCAccount * account = [ZCAccountTool account];
    NSString *url = [NSString stringWithFormat:SEARCHDEATIL_URL,self.detailTradeID,account.userID];
    [self showHudMessage:@"加载中"];
    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.dict = responseObject;
        int code = [[[self.dict objectForKey:@"code"] description] intValue];
        [self hideHud:0];
        if (code == 1) {
            int multi = [[[self.dict objectForKey:@"multi"] description] intValue];
            
            if (multi == 0) {
                
//                [YLNotificationCenter postNotificationName:YLChaxunMingzi object:self.dict[@"baby"]];
                // 搭建UI(因为请求数据时间的原因,必须放在这)
                [self creatSearchDetailViewControllerUI];
            }else {
                [self sendErrorWarning:@"已阅读，退下吧。"];
            }
            
        }else {
            [self sendErrorWarning:self.dict[@"message"]];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideHud:0];
        [self sendErrorWarning:error.localizedDescription];
    }];
    
}


#pragma mark - 搭建UI
- (void)creatSearchDetailViewControllerUI{
    // 创建第一行的订单号的label
    UILabel * orderLabel = [self getLabelFrame:CGRectMake(10, (self.orderView.frame.size.height-20)/2, 200, 20) andText:[NSString stringWithFormat:@"订单号 : %@",self.detailTradeID] andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor colorWithWhite:0.293 alpha:1.000]];
    [self.orderView addSubview:orderLabel];
    UILabel * guestName = [self getLabelFrame:CGRectMake(SCREEN_WIDTH-150, (self.orderView.frame.size.height-20)/2, 140, 20) andText:_dict[@"store"] andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor colorWithWhite:0.293 alpha:1.000]];
    guestName.textAlignment = NSTextAlignmentRight;
    [self.orderView addSubview:guestName];
    
    UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        UIPasteboard *pasted = [UIPasteboard generalPasteboard];
        [pasted setString:self.detailTradeID];
        [self showSuccessTips:@"订单号已复制"];
    }];
    [self.orderView addGestureRecognizer:tapp];
    
    
    // 创建订单进度
    
    if ([[_dict objectForKey:@"process"] description].length < 5) {
        [self showErrorTips:@"数据异常"];
        return;
    }
    
    NSDictionary * dic = _dict[@"process"];
    
    NSArray * detailTitle = @[dic[@"shoot"], dic[@"ps"], dic[@"selectp"], dic[@"exps"], dic[@"design"], dic[@"cdesign"]];
    for (int i = 0 ; i < 6; i++) {
        UILabel * label = [self getLabelFrame:CGRectMake(15 + (SCREEN_WIDTH-30)/6*i, 88+11, (SCREEN_WIDTH-30)/6, 20) andText:detailTitle[i] andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor colorWithRed:0.969 green:0.180 blue:0.231 alpha:1.000]];
        [self.progressView addSubview:label];
    }
    
    // 创建客户信息
    NSMutableString *originTel = _dict[@"paphone"];
    if (originTel.isPhoneNum) {
        NSString *telnumber = [_dict[@"paphone"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.guestInfoTitle = @[[NSString stringWithFormat:@"宝宝姓名: %@", _dict[@"baby"]], [NSString stringWithFormat:@"家长电话: %@",telnumber]];
    }else{
        self.guestInfoTitle = @[[NSString stringWithFormat:@"宝宝姓名: %@", _dict[@"baby"]], [NSString stringWithFormat:@"家长电话: %@",@"该账号没有获得电话的权限"]];
        
    }
    UILabel * label = [self getLabelFrame:CGRectMake(15, (44+20), SCREEN_WIDTH, 20) andText:self.guestInfoTitle[0] andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor colorWithWhite:0.293 alpha:1.000]];
    [self.guestInfo addSubview:label];
    UILabel * label1 = [self getLabelFrame:CGRectMake(15, (44+20)+40, SCREEN_WIDTH, 20) andText:self.guestInfoTitle[1] andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor colorWithWhite:0.293 alpha:1.000]];
    label1.userInteractionEnabled = YES;
    [self.guestInfo addSubview:label1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",originTel]]];
        UIWebView *webView = [[UIWebView alloc]init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",originTel]];
        [webView loadRequest:[NSURLRequest requestWithURL:url ]];
        [self.view addSubview:webView];
    }];
    [label1 addGestureRecognizer:tap];
    
    // 创建套系名称
    NSArray * pakagesArr = [_dict[@"packages"] componentsSeparatedByString:@"/"];
    UILabel * pakagenameLabel = [self getLabelFrame:CGRectMake(SCREEN_WIDTH-150, 11, 140, 20) andText:pakagesArr[0] andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor colorWithWhite:0.293 alpha:1.000]];
    pakagenameLabel.textAlignment = NSTextAlignmentRight;
    [self.pakageView addSubview:pakagenameLabel];
    
    // 付款价格
    int alreadyPay = [[pakagesArr lastObject] intValue]-[_dict[@"balance"] intValue];
    NSString * alreadyPayStr = [NSString stringWithFormat:@"%d",alreadyPay];
    NSArray * payTitle = @[[pakagesArr lastObject], alreadyPayStr, _dict[@"balance"]];
    for (int i = 0; i < 3; i++) {
        UILabel * label = [self getLabelFrame:CGRectMake(SCREEN_WIDTH/3 * i, 88, SCREEN_WIDTH/3, 20) andText:payTitle[i] andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor colorWithRed:0.969 green:0.180 blue:0.231 alpha:1.000]];
        label.textAlignment = NSTextAlignmentCenter;
        [self.payView addSubview:label];
    }
    
    // 是否取件
    UILabel * takeNameLabel = [self getLabelFrame:CGRectMake(SCREEN_WIDTH-150, 11, 140, 20) andText:dic[@"pickup"] andFont:[UIFont systemFontOfSize:15] andTextColor:[UIColor colorWithRed:0.969 green:0.180 blue:0.231 alpha:1.000]];
    takeNameLabel.textAlignment = NSTextAlignmentRight;
    [self.takeView addSubview:takeNameLabel];
}

- (UIView *)getViewFrame:(CGRect)frame {
    UIView * view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [self.backScrollView addSubview:view];
    return view;
}

- (UILabel *)getLabelFrame:(CGRect)frame andText:(NSString *)text andFont:(UIFont *)font andTextColor:(UIColor *)textColor {
    UILabel * label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = text;
    label.font = font;
    label.textColor=textColor;
    return label;
}



@end
