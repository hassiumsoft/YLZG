//
//  TeamPaihangbangViewController.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TeamPaihangbangViewController.h"
#import "DateMineKaoqinPicker.h"
#import "qiaodaocountBtn.h"
#import "TeamPaihangbangTableViewCell.h"
#import "CalendarHomeViewController.h"
#import <MJExtension.h>
#import "NormalIconView.h"
#import <Masonry.h>

@interface TeamPaihangbangViewController ()<DateMineKaoqinPickerDelegate, UITableViewDataSource, UITableViewDelegate>

// seg
@property (nonatomic, strong) UISegmentedControl * seg;
// 底部的白色图片
@property (nonatomic, strong) UIImageView * backImageV;
// 日历
@property (nonatomic, strong) DateMineKaoqinPicker * datePicker;
// 日期
@property (nonatomic, strong) qiaodaocountBtn * dateButton;

/** tableView相关 */
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property(nonatomic,copy)NSString *dateStr;

@end

@implementation TeamPaihangbangViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行榜";
    // 请求数据
//    [self loadTeamPaihangbangViewControllerData];
    // 搭建头部UI
    [self creatTeamPaihangbangViewControllerUI];
    // 表格
//    [self createTabelView];
    
    [self CreateEmptyView:@"还没有数据统计"];
}

- (void)CreateEmptyView:(NSString *)message
{
    // 全部为空值
    NormalIconView *emptyView = [NormalIconView sharedHomeIconView];
    emptyView.iconView.image = [UIImage imageNamed:@"happyness"];
    emptyView.label.text = message;
    emptyView.label.numberOfLines = 0;
    emptyView.label.textColor = RGBACOLOR(209, 40, 123, 1);
    emptyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:emptyView];
    
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-64);
        make.width.and.height.equalTo(@140);
    }];
}



#pragma mark - 请求数据
- (void)loadTeamPaihangbangViewControllerData{
    self.dataSource = [[NSMutableArray alloc] init];
    
    NSArray * arr = @[
                      @{@"iconStr":@"check_hourse" ,@"nameStr":@"虎扑",@"dateStr":@"迟到10分钟"},
                      @{@"iconStr":@"check_hourse",@"nameStr":@"彩票", @"dateStr":@"迟到10分钟"},
                      @{@"iconStr":@"check_hourse",@"nameStr":@"购物", @"dateStr":@"迟到10分钟"},
                      @{@"iconStr":@"check_hourse",@"nameStr":@"运动课", @"dateStr":@"迟到10分钟"}
                      ];
    self.dataSource = [TeamPaihangbangModel mj_objectArrayWithKeyValuesArray:arr];
}


#pragma mark - 搭建UI
- (void)creatTeamPaihangbangViewControllerUI{
    // 多段选择器
    NSArray * titleArr = @[@"累计迟到", @"累计旷工"];
    self.seg = [[UISegmentedControl alloc] initWithItems:titleArr];
    self.seg.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 44);
    self.seg.selectedSegmentIndex = 0;
    [self.view addSubview:self.seg];
    self.seg.tintColor = RGBACOLOR(43, 135, 227, 1);
    // 设置字体颜色
    [self.seg addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // 白色背景图
    _backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.seg.frame)+10, SCREEN_WIDTH-20, SCREEN_HEIGHT-self.seg.height-100)];
    _backImageV.userInteractionEnabled = YES;
    _backImageV.image = [UIImage imageNamed:@"qiandaobeizhu_image"];
    [self.view addSubview:_backImageV];
    
    // 上面的一行
    _dateButton = [qiaodaocountBtn shareqiaodaocountBtn];
    _dateButton.frame = CGRectMake(10, 2, _backImageV.width-20, 44);
    _dateButton.label.text = [self getYearCurrentTime];
    [_dateButton addTarget:self action:@selector(dateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.backImageV addSubview:_dateButton];
    
}

#pragma mark -seg的点击事件相关
- (void)valueChanged:(UISegmentedControl *)seg {
    if (seg.selectedSegmentIndex == 0) {
        NSArray * arr = @[
                          @{@"iconStr":@"check_hourse" ,@"nameStr":@"虎扑",@"dateStr":@"迟到10分钟"},
                          @{@"iconStr":@"check_hourse",@"nameStr":@"彩票", @"dateStr":@"迟到10分钟"},
                          @{@"iconStr":@"check_hourse",@"nameStr":@"购物", @"dateStr":@"迟到10分钟"},
                          @{@"iconStr":@"check_hourse",@"nameStr":@"运动课", @"dateStr":@"迟到10分钟"}
                          ];
        self.dataSource = [TeamPaihangbangModel mj_objectArrayWithKeyValuesArray:arr];
        
    }else {
        NSArray * arr = @[
                           @{@"iconStr":@"check_hourse" ,@"nameStr":@"虎扑1",@"dateStr":@"迟到10分钟"},
                           @{@"iconStr":@"check_hourse",@"nameStr":@"彩票1", @"dateStr":@"迟到10分钟"},
                           @{@"iconStr":@"check_hourse",@"nameStr":@"购物1", @"dateStr":@"迟到10分钟"},
                           @{@"iconStr":@"check_hourse",@"nameStr":@"运动课1", @"dateStr":@"迟到10分钟"},
                           @{@"iconStr":@"check_hourse",@"nameStr":@"运动课1", @"dateStr":@"迟到10分钟"}
                           ];
        self.dataSource = [TeamPaihangbangModel mj_objectArrayWithKeyValuesArray:arr];
    }
//    [self createTabelView];
}

#pragma mark -当前时间
- (NSString *)getYearCurrentTime {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"yyyy年MM月"];
    
    NSString * returnStr = [formatter stringFromDate:[NSDate date]];
    return returnStr;
}

- (void)dateButtonClicked:(UIButton *)sender {
    self.datePicker = [DateMineKaoqinPicker shareDateMineKaoqinPicker];
    self.datePicker.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.datePicker.dvDelegate = self;
    [self.datePicker selectToday];
    
    [self.view.window addSubview:self.datePicker];
}

- (void)yearMonthDatePicker:(DateMineKaoqinPicker *)yearMonthDatePicker didSelectedDate:(NSDate *)date {
    // 2016-06-01 00:00:00 +0000
    NSString * dateStr = [NSString stringWithFormat:@"%@",date];
    NSString *realTime = [dateStr substringWithRange:NSMakeRange(0, 7)];
    NSArray * arr = [realTime componentsSeparatedByString:@"-"];
    NSString * lastStr = [NSString stringWithFormat:@"%@年%@月",arr[0], arr[1]];
    _dateButton.label.text = lastStr;
}


#pragma mark -tableView相关
- (void)createTabelView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_dateButton.frame)+2, self.backImageV.width, self.backImageV.height-_dateButton.height-10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [self.backImageV addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamPaihangbangTableViewCell * cell = [TeamPaihangbangTableViewCell sharedTeamPaihangbangTableViewCell:tableView];
    TeamPaihangbangModel * model = _dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
