//
//  MonthInComeController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/2.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "MonthInComeController.h"
#import "LXMPieView.h"
#import <MJExtension.h>
#import "NormalIconView.h"
#import "ZCAccountTool.h"
#import "FinalTableViewCell.h"
#import "NoColorTableViewCell.h"
#import <Masonry.h>



#define TableWH (55 * 3 + 4)

@interface MonthInComeController ()<LXMPieViewDelegate,UITableViewDelegate,UITableViewDataSource>

/** 饼状图 */
@property (strong,nonatomic) LXMPieView *pieView;
/** 出现空值时的视图 */
@property (strong,nonatomic) NormalIconView *emptyBtn;
/** 月份 */
@property (strong,nonatomic) UILabel *monthLabel;
/** 表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 总收入/支出 */
@property (strong,nonatomic) UILabel *sumLabel;

@end

@implementation MonthInComeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];
    [self.view addSubview:self.tableView];
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xian"]];
    [self.view addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tableView.mas_left);
        make.right.equalTo(_tableView.mas_right);
        make.bottom.equalTo(_tableView.mas_bottom).offset(-2);
        make.height.equalTo(@2);
    }];
}

#pragma mark - 刷新饼干
- (void)reloadData
{
    [self.pieView removeFromSuperview];
    [self.sumLabel removeFromSuperview];
    [self.monthLabel removeFromSuperview];
    
    [self setupSubViews];
    
    [self.tableView reloadData];
}
#pragma mark - 表格相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        FinalTableViewCell *cell = [FinalTableViewCell sharedFinalTableViewCell:tableView];
        return cell;
    }else if (indexPath.row == 1){
        NoColorTableViewCell *cell = [NoColorTableViewCell sharedNoColorTableViewCell:tableView];
        self.inModel.isPresent = YES;
        cell.model = self.inModel;
        return cell;
    }else{
        NoColorTableViewCell *cell = [NoColorTableViewCell sharedNoColorTableViewCell:tableView];
        self.inModel.isPresent = NO;
        cell.model = self.inModel;
        return cell;
    }
}


- (void)setupSubViews
{
    // 前期、摄影二次销售、化妆二次销售、选片二次销售
    NSMutableArray *modelArray = [NSMutableArray array];
    //  ⚠️ 有些月份会出现空值--只要有一个不为空那就不崩溃
    if (([self.inModel.totalin doubleValue] == 0.f)) {
        // 全部为空值
        
        CATransition *animation = [CATransition animation];
        animation.duration = 2.f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"rippleEffect";
        animation.subtype = kCATransitionFromTop;
        [self.view.window.layer addAnimation:animation forKey:nil];
        
        // 全部为空值
        self.emptyBtn = [NormalIconView sharedHomeIconView];
        self.emptyBtn.iconView.image = [UIImage imageNamed:@"sadness"];
        self.emptyBtn.label.text = @"暂无收入";
        self.emptyBtn.label.textColor = RGBACOLOR(219, 99, 155, 1);
        self.emptyBtn.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.emptyBtn];
        
        
        [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).offset(-64);
            make.width.and.height.equalTo(@140);
        }];
        
        
        return;
    }
    
    NSString *qianqi = self.inModel.prepro;
    NSString *sheying = self.inModel.ptsell;
    NSString *huazhuang = self.inModel.mptsell;
    NSString *qujian = self.inModel.sptsell;
    
    if (!qianqi) {
        qianqi = @"0";
    }
    if (!sheying) {
        sheying = @"0";
    }
    if (!huazhuang) {
        huazhuang = @"0";
    }
    if (!qujian) {
        qujian = @"0";
    }
    
    NSArray *valueArray = @[qianqi, sheying, huazhuang, qujian];
    
    NSArray *colorArray = @[[UIColor purpleColor], // 前期
                            [UIColor brownColor], // 摄影
                            RGBACOLOR(246, 91, 78, 1),  // 化妆
                            RGBACOLOR(135, 205, 121, 1),];  // 取件
    for (int i = 0 ; i <valueArray.count ; i++) {
        LXMPieModel *model = [[LXMPieModel alloc] initWithColor:colorArray[i] value:[valueArray[i] floatValue] text:nil];
        [modelArray addObject:model];
    }
    
    CGFloat spaceY;  // Y值，为了处理4S
    CGFloat X;  // 宽高
    
    if (SCREEN_WIDTH == 320) {
        spaceY = 20 * CKproportion;
        X = 60;
    } else {
        spaceY = 40 * CKproportion;
        X = 45;
    }
    
    LXMPieView *pieView = [[LXMPieView alloc] initWithFrame:CGRectMake(X, spaceY, SCREEN_WIDTH - X * 2, SCREEN_WIDTH - X * 2) values:modelArray];
    pieView.delegate = self;
    pieView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pieView];
    
    self.pieView = pieView;
    
    /** 下面的图层 **/
    
    // 月份
    [self.view addSubview:self.monthLabel];
    [self.view addSubview:self.sumLabel];
    
    self.sumLabel.text = [NSString stringWithFormat:@"￥%@",self.inModel.totalin];
    self.monthLabel.text = self.month;
    
}

- (void)setMonth:(NSString *)month
{
    _month = month;
    self.monthLabel.text = month;
}

#pragma mark -- 选中哪一块饼干
- (void)lxmPieView:(LXMPieView *)pieView didSelectSectionAtIndex:(NSInteger)index {
    KGLog(@"didSelectSectionAtIndex : %ld", (long)index);
    switch (index) {
            case 0:
        {
            // 前期收入
            
            break;
        }
            case 1:
        {
            // 摄影收入
            break;
        }
            case 2:
        {
            // 化妆收入
            break;
        }
            case 3:
        {
            // 选片收入
            break;
        }
        default:
            break;
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TableWH - 64, SCREEN_WIDTH, TableWH)];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}
- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 10, 90, 21)];
        _monthLabel.backgroundColor = [UIColor clearColor];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _monthLabel;
}
- (UILabel *)sumLabel
{
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(21, 10, 90, 21)];
        _sumLabel.backgroundColor = [UIColor clearColor];
        _sumLabel.font = [UIFont systemFontOfSize:15];
    }
    return _sumLabel;
}

@end
