//
//  ChangeRulesController.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/6/8.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "ChangeRulesController.h"
#import "NormalTableCell.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "HomeNavigationController.h"
#import "PlaceViewController.h"
#import "GudingBanciVController.h"
#import <AFNetworking.h>
#import <MJExtension.h>

#import "ZCAccountTool.h"
#import "ChooseBanciVController.h"
#import "TanxingBanciSettingController.h"
#import "HengpinNavController.h"
#import <Masonry.h>
#import "HTTPManager.h"



@interface ChangeRulesController ()<UITableViewDelegate,UITableViewDataSource,PlaceDidSelcedDelegate,GudingBanciDelegate,ChooseBanciDelegate,TanxingBanSetDelegate>

{
    BOOL isSetTanxing; // 是否设置好弹性时间
}
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 考勤时间 */
@property (copy,nonatomic) NSString *time;
/** 完成按钮 */
@property (strong,nonatomic) UIButton *button;

/** wifi名称数组 */
@property (strong,nonatomic) NSMutableArray *wifiNameArr;
/** 打卡位置名称 */
@property (strong,nonatomic) NSMutableArray *placeNamaArr;

/** wifi数组底部视图 */
@property (strong,nonatomic) UIView *wifiView;
/** 办公地址父视图 */
@property (strong,nonatomic) UIView *placeView;
/** 有效范围 */
@property (strong,nonatomic) UITextField *areaField;

@property (strong,nonatomic) NSMutableArray *wifiBtnArray;
@property (strong,nonatomic) NSMutableArray *placeBtnArray;



/** 地址数组的json串 */
@property (copy,nonatomic) NSString *placeJson;
/** 地址数组,装着字典 */
@property (strong,nonatomic) NSMutableArray *placeInfoArray;

/** wifi数组的json串 */
@property (copy,nonatomic) NSString *wifiJson;
/** wifi数组,没用到 */
@property (strong,nonatomic) NSMutableArray *wifiArray;

/** 班次时间的json串 */
@property (copy,nonatomic) NSString *banciTimeJsonStr;
/** 弹性班次的模型数组 */
@property (strong,nonatomic) NSMutableArray *tanxingBanciModelArray;


/** 需要懒加载属性 */
@property (strong,nonatomic) UILabel *kaoqinLabel;
@property (strong,nonatomic) UILabel *timeLabel;


@end

@implementation ChangeRulesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}
- (void)setupSubViews
{
    if (!self.model) {
        KGLog(@"self.model    =======    nil");
        //   赋值
        
    }else{
        KGLog(@"self.model    !!!!===    nil");
        //   设置
        self.type = self.model.type;
        
    }
    if ([self.type intValue] == 1) {
        self.title = @"设置固定班制规则";
    }else{
        self.title = @"设置弹性班制规则";
    }
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.wifiBtnArray = [NSMutableArray array];
    self.placeBtnArray = [NSMutableArray array];
    
    self.time = @"";
    self.wifiNameArr = [NSMutableArray arrayWithObjects:@"＋",nil];
    self.placeNamaArr = [NSMutableArray arrayWithObjects:@"＋", nil];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60 - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.tableView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), SCREEN_WIDTH, 60)];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:backView];
    
    isSetTanxing = NO;
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setBackgroundColor:MainColor];
    self.button.layer.cornerRadius = 5;
    self.button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([_type intValue] == 1) {
        [self.button setTitle:@"完  成" forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(saveRuleAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.button setTitle:@"下一步" forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(nextPaibanSetting) forControlEvents:UIControlEventTouchUpInside];
    }
    [backView addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.centerX.equalTo(backView.mas_centerX);
        make.height.equalTo(@40);
        make.left.equalTo(backView.mas_left).offset(25);
    }];
}

#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        if (self.time.length < 2) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        // "考勤时间"文字
        
        [cell.contentView addSubview:self.kaoqinLabel];
        // 每周几周几
        self.timeLabel.text = self.time;
        [cell.contentView addSubview:self.timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right).offset(-15);
            make.top.equalTo(self.kaoqinLabel.mas_bottom).offset(5);
            make.bottom.equalTo(cell.mas_bottom).offset(-8);
        }];
        return cell;
    } else if(indexPath.section == 1){
        // wifi设置
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        // 房屋icon
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check_hourse"]];
        [imageV setFrame:CGRectMake(20, 10, 60, 60)];
        [cell.contentView addSubview:imageV];
        
        // wifi说明
        UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+15, 15, SCREEN_WIDTH - 100, 50)];
        timeL.text = @"根据WiFi精确定位\r适用于在办公室或一层楼内考勤";
        timeL.font = [UIFont systemFontOfSize:15];
        timeL.textColor = [UIColor grayColor];
        timeL.numberOfLines = 2;
        [cell.contentView addSubview:timeL];
        // 线
        UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
        [xian setFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+5, SCREEN_WIDTH, 2)];
        
        [cell addSubview:xian];
        
        
        [cell.contentView addSubview:self.wifiView];
        CGFloat W = 0; // 保存前一个button的宽以及前一个button距离边沿的距离
        CGFloat H = 5; // 用来约束控制button距离父控件视图的高
        for (int i = 0; i < self.wifiNameArr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 100 + i;
            [button setTitle:self.wifiNameArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15 * CKproportion];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = 2;
            button.backgroundColor = HWRandomColor;
            
            // 计算大小
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]};
            CGFloat length = [self.wifiNameArr[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            
            
            // 设置button的坐标
            button.frame = CGRectMake(W + 10, H, length + 20*CKproportion, 25);
            if(W + 10 + length + 10 > SCREEN_WIDTH - 30){
                W = 0; //换行时将w置为0
                H = H + button.frame.size.height + 10;//距离父视图也变化
                button.frame = CGRectMake(W + 10, H, length + 20*CKproportion, 25);//重设button的frame
            }
            
            W = button.frame.size.width + button.frame.origin.x;
            [self.wifiView addSubview:button];
            CGRect rect = self.wifiView.frame;
            rect.size.height = H + 30;
            self.wifiView.frame = rect;
            
            // 设置最后一个添加按钮的相关属性
            if (i == self.wifiNameArr.count - 1) {
                button.backgroundColor = [UIColor clearColor];
                [button addTarget:self action:@selector(addWifiAction) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:@"" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"add_group"] forState:UIControlStateNormal];
            }
            
            [self.wifiBtnArray addObject:button];
        }
        
        
        return cell;
    }else if(indexPath.section == 2){
        //  楼房区域设置
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        // 大楼icon
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"check_dalou"]];
        [imageV setFrame:CGRectMake(20, 10, 60, 60)];
        [cell.contentView addSubview:imageV];
        
        // wifi地址说明
        UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+15, 15, SCREEN_WIDTH - 100, 50)];
        timeL.text = @"根据办公地址\r适用于在一栋大楼或一个区域考勤";
        timeL.font = [UIFont systemFontOfSize:15];
        timeL.textColor = [UIColor grayColor];
        timeL.numberOfLines = 2;
        [cell.contentView addSubview:timeL];
        // 线
        UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
        [xian setFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+5, SCREEN_WIDTH, 2)];
        
        [cell addSubview:xian];
        // 地址
        [cell.contentView addSubview:self.placeView];
        CGFloat W = 0; // 保存前一个button的宽以及前一个button距离边沿的距离
        CGFloat H = 5; // 用来约束控制button距离父控件视图的高
        for (int i = 0; i < self.placeNamaArr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 100 + i;
            [button setTitle:self.placeNamaArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15 * CKproportion];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = 2;
            button.backgroundColor = HWRandomColor;
            
            // 计算大小
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]};
            CGFloat length = [self.placeNamaArr[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
           
            
            // 设置button的坐标
            button.frame = CGRectMake(W + 10, H, length + 20*CKproportion, 25);
            if(W + 10 + length + 10 > SCREEN_WIDTH - 30){
                W = 0; //换行时将w置为0
                H = H + button.frame.size.height + 10;//距离父视图也变化
                button.frame = CGRectMake(W + 10, H, length + 20*CKproportion, 25);//重设button的frame
            }
            
            W = button.frame.size.width + button.frame.origin.x;
            [self.placeView addSubview:button];
            CGRect rect = self.wifiView.frame;
            rect.size.height = H + 30;
            self.placeView.frame = rect;
            
          // 设置最后一个添加按钮的相关属性
            if (i == self.placeNamaArr.count - 1) {
                button.backgroundColor = [UIColor clearColor];
                [button addTarget:self action:@selector(addPlaceClick) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:@"" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"add_group"] forState:UIControlStateNormal];
            }
            
            [self.placeBtnArray addObject:button];
            
        }
        
        return cell;
    }else{
        // 有效范围
        NormalTableCell *cell = [NormalTableCell sharedNormalTableCell:tableView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell addSubview:self.areaField];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        if ([self.type intValue] == 1) {
            // 固定班次
            GudingBanciVController *guding = [GudingBanciVController new];
            guding.delegate = self;
            [self.navigationController pushViewController:guding animated:YES];
        }else{
            // 弹性班次
            ChooseBanciVController *choose = [ChooseBanciVController new];
            choose.delegate = self;
             [self.navigationController pushViewController:choose animated:YES];
        }
    }
}
- (void)chooseOneBanciWithModel:(BanciModel *)model
{
    
}
#pragma mark - 添加WiFi
- (void)addWifiAction
{
    NSString *wifiName = [self getWifiName];
//    for (NSString *name in self.wifiNameArr) {
//        if ([wifiName isEqualToString:name]) {
//            [MBProgressHUD showError:@"已添加过"];
//            return;
//        }
//    }
    if (wifiName) {
        
        for (UIButton *button in self.wifiBtnArray) {
            [button removeFromSuperview];
        }
        
        [self.wifiNameArr insertObject:wifiName atIndex:0];
        
        [self.tableView reloadData];
    }else{
        [self sendErrorWarning:@"添加失败，请成功连接WiFi之后重试。"];
    }
}
#pragma mark - 添加打卡地址
- (void)addPlaceClick
{
    PlaceViewController *placeVC = [PlaceViewController new];
    placeVC.delegate = self;
    HomeNavigationController *nav = [[HomeNavigationController alloc]initWithRootViewController:placeVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)placeDidselectedWithModel:(BMKPoiInfo *)model WithPlaceinfo:(NSDictionary *)dict
{
    for (UIButton *button in self.placeBtnArray) {
        [button removeFromSuperview];
    }
    [self.placeNamaArr insertObject:model.address atIndex:0];
    [self.tableView reloadData];
    
    [self.placeInfoArray addObject:dict];
}
#pragma mark - 排班制时的回调-班次
- (void)chooseMoreBanciWithArray:(NSArray *)modelAray
{
    
    self.tanxingBanciModelArray = [modelAray copy];
    self.time = @"";
    NSMutableString *formatStr = [NSMutableString new];
    for (int i = 0; i < modelAray.count; i++) {
        BanciModel *banciModel = modelAray[i];
        NSString *timeStr;
        if (i == 0) {
            timeStr = [NSString stringWithFormat:@"%@(%@-%@)",banciModel.classname,banciModel.start,banciModel.end];
        }else{
            timeStr = [NSString stringWithFormat:@"、%@(%@-%@)",banciModel.classname,banciModel.start,banciModel.end];
        }
        formatStr = (NSMutableString *)[formatStr stringByAppendingString:timeStr];
        KGLog(@"kk = %@",formatStr);
    }
    self.time = formatStr;
    [self.tableView reloadData];
}
#pragma mark - 班次时间的回调
- (void)gudingbanciWithJsonStr:(NSString *)jsonStr WithModelArray:(NSArray *)modelArray
{

    self.time = @"";
    self.banciTimeJsonStr = jsonStr;
    NSMutableString *formatStr = [NSMutableString new];
    for (int i = 0; i < modelArray.count; i++) {
        GudingPaibanModel *paibanModel = modelArray[i];
        NSString *timeStr;
        if (i == 0) {
            if (paibanModel.start.length < 1) {
                timeStr = [NSString stringWithFormat:@"%@(休息)",paibanModel.week];
            }else{
                timeStr = [NSString stringWithFormat:@"%@(%@-%@)",paibanModel.week,paibanModel.start,paibanModel.end];
            }
            
        }else{
            if (paibanModel.start.length < 1) {
                timeStr = [NSString stringWithFormat:@"、%@(休息)",paibanModel.week];
            }else{
                timeStr = [NSString stringWithFormat:@"、%@(%@-%@)",paibanModel.week,paibanModel.start,paibanModel.end];
            }
        }
        
        formatStr = (NSMutableString *)[formatStr stringByAppendingString:timeStr];
        KGLog(@"kk = %@",formatStr);
    }
    self.time = formatStr;
    [self.tableView reloadData];
}
#pragma mark - 弹性制设置班次
- (void)nextPaibanSetting
{
    if (isSetTanxing) {
        [self saveRuleAction];
    }else{
        if (self.tanxingBanciModelArray.count < 1) {
            [self showErrorTips:@"请选择考勤时间"];
            return;
        }
        TanxingBanciSettingController *tanxingSet = [TanxingBanciSettingController new];
        tanxingSet.delegate = self;
        tanxingSet.banciModelArray = [NSMutableArray arrayWithArray:self.tanxingBanciModelArray];
        // json串转成
        tanxingSet.membersArray = self.staffArray;
        HengpinNavController *hengpingNav = [[HengpinNavController alloc]initWithRootViewController:tanxingSet];
        [self presentViewController:hengpingNav animated:YES completion:^{
            
        }];
    }
}
#pragma mark - 弹性班次回调代理
- (void)tanxingBanxiWithRulesJson:(NSString *)rulesJson
{
    self.banciTimeJsonStr = [rulesJson copy];
    KGLog(@"self.banciTimeJsonStr = %@",self.banciTimeJsonStr);
    isSetTanxing = YES;
    [self.button setTitle:@"完  成" forState:UIControlStateNormal];
}
#pragma mark - 完成设置
- (void)saveRuleAction
{
    
    // wifi
    [self.wifiNameArr removeLastObject];  // 去掉加号
    
//    [self.wifiNameArr addObject:@"CMCC_WLAN"]; // 模拟器测试用
    
    if (self.wifiNameArr.count < 1) {
        [self showErrorTips:@"请连接有效WiFi"];
        return;
    }
    if (self.areaField.text.length < 1) {
        [self showErrorTips:@"请设置有效范围"];
        return;
    }
    if (self.placeInfoArray.count < 1) {
        [self showErrorTips:@"请选择位置"];
        return;
    }
    if (self.banciTimeJsonStr.length < 5) {
        [self showErrorTips:@"请设置好班次时间"];
        return;
    }
    
    //
    self.wifiJson = [self toJsonStr:self.wifiNameArr];
    // 地址
    self.placeJson = [self toJsonStr:self.placeInfoArray];
    KGLog(@"self.placeJson = %@",self.placeJson);
    
    ZCAccount *account = [ZCAccountTool account];
    
    NSString *url = CreateKaoqunGroup_Url;

    [MBProgressHUD showMessage:@"设置中"];
//    http://zsylou.wxwkf.com/index.php/home/attence/new_attence_group?uid=%@&name=%@&type=%@&admins=%@&routers=%@&locations=%@&privilege_meter=%@&rules=%@&users=%@
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:account.userID forKey:@"uid"];
    [params setValue:self.name forKey:@"name"];
    [params setValue:self.type forKey:@"type"];
    [params setValue:self.adminArrJson forKey:@"admins"];
    [params setValue:self.wifiJson forKey:@"routers"];
    [params setValue:self.placeJson forKey:@"locations"];
    [params setValue:self.areaField.text forKey:@"privilege_meter"];
    [params setValue:self.banciTimeJsonStr forKey:@"rules"];
    [params setValue:self.memArrJson forKey:@"users"];
    
    /****************************************************************/
    

    [HTTPManager POST:url params:params success:^(NSURLSessionDataTask *task, id responseObject) {

            [MBProgressHUD hideHUD];
            KGLog(@"json = %@",responseObject);
            NSString *message = [[responseObject objectForKey:@"message"]description];
            int code = [[[responseObject objectForKey:@"code"] description] intValue];
            if (code == 1) {
                
                NSString *message;
                if ([self.type intValue] == 1) {
                    message = @"固定班次设置成功";
                }else{
                    message = @"弹性班制设置成功，您可以前往后台管理系统完善未来一个月内的排班";
                }
                
                // 设置成功，告诉上个界面刷新。返回
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                
                [alertC addAction:action1];
                [self presentViewController:alertC animated:YES completion:^{
                    
                }];
            }else{
                // 设置失败
                
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                [alertC addAction:action1];
                [self presentViewController:alertC animated:YES completion:^{
                    
                }];
            }


    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [self sendErrorWarning:error.localizedDescription];
        KGLog(@"%@",error.localizedDescription);
    }];
    
    
    
}



#pragma mark - 其他设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGRect rect = [self.time boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40, 120) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        return rect.size.height + 50;
    }else if (indexPath.section == 1) {
        return 77 + self.wifiView.height;
    }else if(indexPath.section == 2){
        return 77 + self.placeView.height;
    }else{
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < 3) {
        return 31;
    }else{
        return 1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < 3) {
        NSArray *array = @[@"对'考勤'的考勤组进行设置",@"设置打卡时的办公WiFi",@"设置打卡时的办公地址",@"有效范围"];
        UIView *head = [[UIView alloc]initWithFrame:CGRectZero];
        head.backgroundColor = self.view.backgroundColor;
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 40, 21)];
        titleL.textColor = RGBACOLOR(70, 20, 8, 1);
        titleL.font = [UIFont systemFontOfSize:15];
        titleL.text = array[section];
        [head addSubview:titleL];
        return head;
    }else{
        return nil;
    }
}
#pragma mark - 获取wifi名字
- (NSString *)getWifiName
{
    NSString *wifiName = nil;
    CFArrayRef wifiInterFaces = CNCopySupportedInterfaces();
    if (!wifiInterFaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)(wifiInterFaces);
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName);
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)(dictRef);
            KGLog(@"networkInfo = %@",networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterFaces);
    return wifiName;
}
- (UIView *)wifiView
{
    if (!_wifiView) {
        _wifiView = [[UIView alloc]initWithFrame:CGRectMake(0, 77, SCREEN_WIDTH, 100)];
    }
    return _wifiView;
}
- (NSMutableArray *)wifiArray
{
    if (!_wifiArray) {
        _wifiArray = [[NSMutableArray alloc]init];
    }
    return _wifiArray;
}
- (NSMutableArray *)placeInfoArray
{
    if (!_placeInfoArray) {
        _placeInfoArray = [[NSMutableArray alloc]init];
    }
    return _placeInfoArray;
}
- (UIView *)placeView
{
    if (!_placeView) {
        _placeView = [[UIView alloc]initWithFrame:CGRectMake(0, 77, SCREEN_WIDTH, 100)];
    }
    return _placeView;
}
- (UILabel *)kaoqinLabel
{
    if (!_kaoqinLabel) {
        _kaoqinLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 110, 22)];
        _kaoqinLabel.text = @"考勤时间";
        _kaoqinLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    }
    return _kaoqinLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = self.time;
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.numberOfLines = 0;
        
    }
    return _timeLabel;
}

- (UITextField *)areaField
{
    if (!_areaField) {
        _areaField = [[UITextField alloc]initWithFrame:CGRectMake(20, 7, SCREEN_WIDTH - 40, 36)];
        _areaField.placeholder = @"400米";
        UILabel *leftV = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 125, 36)];
        leftV.text = @"设置有效范围：";
        
        _areaField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _areaField.leftView = leftV;
        _areaField.leftViewMode = UITextFieldViewModeAlways;
        _areaField.keyboardType = UIKeyboardTypeNumberPad;
        
        
    }
    return _areaField;
}

#pragma mark -  将字典或数组转化为JSON串
- (NSString *)toJsonStr:(id)object
{
    NSError *error = nil;
    // ⚠️ 参数可能是模型数组，需要转字典数组
    if (object) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData.length < 5 || error) {
            KGLog(@"解析错误");
        }
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}
//支持旋转
- (BOOL)shouldAutorotate{
    return YES;
}

//支持的方向 因为界面A我们只需要支持竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
