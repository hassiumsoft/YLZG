//
//  MonthOutComeController.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/2.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "MonthOutComeController.h"
#import "LXMPieView.h"
#import <MJExtension.h>
#import "NormalIconView.h"
#import "ZCAccountTool.h"
#import "OutNoColorTableCell.h"
#import "OutComeColorCell.h"
#import <Masonry.h>

#define TableWH (55 * 3 + 4)

@interface MonthOutComeController ()<LXMPieViewDelegate,UITableViewDelegate,UITableViewDataSource>

/** 饼状图 */
@property (strong,nonatomic) LXMPieView *pieView;
/** 出现空值时的视图 */
@property (strong,nonatomic) NormalIconView *emptyView;
/** 月份 */
@property (strong,nonatomic) UILabel *monthLabel;
/** 详细表格 */
@property (strong,nonatomic) UITableView *tableView;
/** 总收入/支出 */
@property (strong,nonatomic) UILabel *sumLabel;

@end

@implementation MonthOutComeController

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
    [self.emptyView removeFromSuperview];
    
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        OutComeColorCell *cell = [OutComeColorCell sharedFinalTableViewCell:tableView];
        return cell;
    }else if (indexPath.row == 1){
        OutNoColorTableCell *cell = [OutNoColorTableCell sharedOutNoColorTableCell:tableView];
        self.outModel.isPresent = YES;
        cell.outModel = self.outModel;
        return cell;
    }else{
        OutNoColorTableCell *cell = [OutNoColorTableCell sharedOutNoColorTableCell:tableView];
        self.outModel.isPresent = NO;
        cell.outModel = self.outModel;
        return cell;
    }
}



- (void)setupSubViews
{
    
    // 工资、房租、生活费、水电费、办公用品、油费
    NSMutableArray *modelArray = [NSMutableArray array];
    //  ⚠️ 有些月份会出现空值--只要有一个不为空那就不崩溃
    if (([self.outModel.totalout doubleValue] == 0.f)) {
        // 全部为空值
        self.emptyView = [NormalIconView sharedHomeIconView];
        self.emptyView.iconView.image = [UIImage imageNamed:@"sadness"];
        self.emptyView.label.text = @"暂无支出";
        self.emptyView.label.textColor = RGBACOLOR(219, 99, 155, 1);
        self.emptyView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.emptyView];
        
        
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY).offset(-64);
            make.width.and.height.equalTo(@140);
        }];
        
        return;
    }
    
    NSString *office = self.outModel.office;
    NSString *oil = self.outModel.oil;
    NSString *salary = self.outModel.salary;
    NSString *water = self.outModel.water;
    NSString *rent = self.outModel.rent;
    NSString *live = self.outModel.live;
    
    if (!office) {
        office = @"0";
    }
    if (!oil) {
        oil = @"0";
    }
    if (!salary) {
        salary = @"0";
    }
    if (!water) {
        water = @"0";
    }
    if (!live) {
        live = @"0";
    }
    if (!rent) {
        rent = @"0";
    }
    
    NSArray *valueArray = @[office,oil,salary,water,rent,live];
    NSArray *colorArray = @[[UIColor purpleColor], // 办公用品
                            RGBACOLOR(18, 131, 205, 1), // 油费
                            RGBACOLOR(246, 91, 78, 1),  // 工资
                            RGBACOLOR(135, 205, 121, 1),  // 水电费
                            RGBACOLOR(75, 55, 181, 1),  // 房租
                            [UIColor brownColor]     // 生活费
                            ];
    for (int i = 0 ; i < valueArray.count ; i++) {
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
    [self.view addSubview:self.monthLabel];
    [self.view addSubview:self.sumLabel];
    self.sumLabel.text = [NSString stringWithFormat:@"￥%@",self.outModel.totalout];
    self.monthLabel.text = self.month;
    
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

- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 10, 90, 21)];
        _monthLabel.backgroundColor = [UIColor clearColor];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
    }
    return _monthLabel;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TableWH - 64, SCREEN_WIDTH, TableWH)];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
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
