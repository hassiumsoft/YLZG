//
//  MineKaoqinView.m
//  ChatDemo-UI3.0
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MineKaoqinView.h"
#import "UIView+Extension.h"
#import "DateMineKaoqinPicker.h"
#import "MineKaoqinTableViewCell.h"
#import "ZCAccountTool.h"
#import <SVProgressHUD.h>
#import "HTTPManager.h"
#import <AFNetworking.h>
#import "UserInfoManager.h"
#import "CalendarHomeViewController.h"




@interface MineKaoqinView ()<DateMineKaoqinPickerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView * backImageV;
@property (nonatomic, strong) UIView * rightView;

// 底层的日期
@property (nonatomic, strong) UIView * dateBtn;
// 年
@property (nonatomic, strong) UILabel * yearLabel;
// 月
@property (nonatomic, strong) UIButton * monthBtn;
// 日历
@property (nonatomic, strong) DateMineKaoqinPicker * datePicker;

/** tableview */
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * countArray;
@property (nonatomic, strong) NSMutableArray * dataSource;


@end

@implementation MineKaoqinView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        
        [self getDateWithMonth:[self getMonthCurrentTime]];
        [self createView];
        [self createTableView];
    }
    return self;
}

- (void)createView {
    self.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    
    UserInfoModel *user = [UserInfoManager getUserInfo];
    if ([user.type isEqualToString:@"1"]) {
         _backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-190)];
    }else {
         _backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-130)];
    }
    _backImageV.userInteractionEnabled = YES;
    _backImageV.image = [UIImage imageNamed:@"qiandaobeizhu_image"];
    [self addSubview:_backImageV];
    
    
    _dateBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    _dateBtn.backgroundColor = [UIColor whiteColor];
    _dateBtn.layer.cornerRadius = 5;
    [self.backImageV addSubview:_dateBtn];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    [_dateBtn addGestureRecognizer:tap];

    
    _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 30, 100, 20)];
    _yearLabel.text = [self getYearCurrentTime];
    [_dateBtn addSubview:_yearLabel];
    
    _monthBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_yearLabel.frame)+8, 120, 40)];
    _monthBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_monthBtn setImage:[self OriginImage:[UIImage imageNamed:@"own_attendance_selectdate"] scaleToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    _monthBtn.userInteractionEnabled = NO;
    [_monthBtn setTitle:[NSString stringWithFormat:@"%@月", [self getMonthCurrentTime]] forState:UIControlStateNormal];
    [_monthBtn setTitleColor:RGBACOLOR(74, 74, 74, 1) forState:UIControlStateNormal];
    _monthBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
    _monthBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [_dateBtn addSubview:_monthBtn];
    
    [self getLabelFrame:CGRectMake(0, CGRectGetMaxY(_dateBtn.frame), _backImageV.width, 0.5)];
    [self getLabelFrame:CGRectMake(CGRectGetMaxX(_dateBtn.frame), 0, 0.5, _dateBtn.height)];
    
    [self hh];
}

- (void)createUIWithData {
    _rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dateBtn.frame)+1, 0, _backImageV.width-_dateBtn.width, _dateBtn.height)];
    _rightView.layer.cornerRadius = 10;
    _rightView.backgroundColor = [UIColor whiteColor];
    [_backImageV addSubview:_rightView];
    // 正常考勤
    UILabel * zhengchangLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, _backImageV.width-_dateBtn.width, _dateBtn.height/2)];
    zhengchangLabel.numberOfLines = 0;
    zhengchangLabel.textAlignment = NSTextAlignmentCenter;
    zhengchangLabel.textColor = RGBACOLOR(74, 74, 74, 1);
    zhengchangLabel.font = [UIFont systemFontOfSize:14];
    zhengchangLabel.text = [NSString stringWithFormat:@"正常考勤\n%lu天", (unsigned long)[_countArray[0]count]];
    [_rightView addSubview:zhengchangLabel];
    
    [self getLabelFrame:CGRectMake(CGRectGetMaxX(_dateBtn.frame), CGRectGetMaxY(zhengchangLabel.frame), zhengchangLabel.width, 0.5)];
    // @"迟到", @"旷工", @"早退", @"缺卡, @"外勤"
    NSArray * titileArr = @[[NSString stringWithFormat:@"迟到\n%lu次",(unsigned long)[_dataSource[0] count]], [NSString stringWithFormat:@"早退\n%lu次",(unsigned long)[_dataSource[2] count]], [NSString stringWithFormat:@"缺卡\n%lu次",(unsigned long)[_dataSource[3] count]], [NSString stringWithFormat:@"旷工\n%lu次",(unsigned long)[_dataSource[1] count]]];
    
    for (int i = 0 ; i < titileArr.count; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(zhengchangLabel.frame)+zhengchangLabel.width/4*i, CGRectGetMaxY(zhengchangLabel.frame)+8, zhengchangLabel.width/4, 40)];
        label.numberOfLines = 0;
        label.text = titileArr[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGBACOLOR(74, 74, 74, 1);
        label.textAlignment = NSTextAlignmentCenter;
        [_rightView addSubview:label];
    }
}



/**  时间相关 */
#pragma mark - 选择时间
- (void)tapClicked:(UITapGestureRecognizer *)tap {
    
    self.datePicker = [DateMineKaoqinPicker shareDateMineKaoqinPicker];
    self.datePicker.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.datePicker.dvDelegate = self;
    [self.datePicker selectToday];
    [self.window addSubview:self.datePicker];
}



- (void)yearMonthDatePicker:(DateMineKaoqinPicker *)yearMonthDatePicker didSelectedDate:(NSDate *)date {
    // 2016-06-01 00:00:00 +0000
    NSString * dateStr = [NSString stringWithFormat:@"%@",date];
    NSString *realTime = [dateStr substringWithRange:NSMakeRange(0, 7)];
    NSArray * arr = [realTime componentsSeparatedByString:@"-"];
    
    if ([arr[0] compare:[self getYearCurrentTime]] == 0 && [arr[1] compare:[self getMonthCurrentTime]]<=0) {
        _yearLabel.text = [NSString stringWithFormat:@"%@年", arr[0]];
        [_monthBtn setTitle:[NSString stringWithFormat:@"%@月", arr[1]] forState:UIControlStateNormal];
        [self hh];
        // 选择时间的时候重新获取接口
        [self getDateWithMonth:arr[1]];
    }else {
        [self.superCheckController sendErrorWarning:@"时间不能大于当前时间"];
    }
}
#pragma mark -富文本
- (void)hh {
    // 富文本
    NSMutableAttributedString * graytext = [[NSMutableAttributedString alloc] initWithString:self.monthBtn.titleLabel.text];
    [graytext beginEditing];
    //字体大小
    [graytext addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:32] range:NSMakeRange(0, self.monthBtn.titleLabel.text.length-1)];
    [graytext addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, self.monthBtn.titleLabel.text.length-1)];
    self.monthBtn.titleLabel.attributedText =  graytext;
}

#pragma mark -当前时间
- (NSString *)getYearCurrentTime {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"yyyy"];
    
    NSString * returnStr = [formatter stringFromDate:[NSDate date]];
    return returnStr;
}

- (NSString *)getMonthCurrentTime {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"MM"];
    
    NSString * returnStr = [formatter stringFromDate:[NSDate date]];
    return returnStr;
}

#pragma mark -改变图片的大小
-(UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage; //返回的就是已经改变的图片
}

#pragma mark -创建label相关
- (UILabel *)getLabelFrame:(CGRect)frame {
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = RGBACOLOR(228, 228, 228, 1);
    [self.backImageV addSubview:label];
    return label;
}


/************ tableView相关 ************/
- (void)initData {
    self.dataSource = [[NSMutableArray alloc] init];
    self.countArray = [[NSMutableArray alloc] init];
}

- (void)getDateWithMonth:(NSString *)monthStr{

    [SVProgressHUD showWithStatus:@"努力加载中..."];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    ZCAccount * account = [ZCAccountTool account];
    NSString * url = [NSString stringWithFormat:Count_MyKaoqin_Url, account.userID, monthStr];

    [HTTPManager GET:url params:nil success:^(NSURLSessionDataTask *task, id responseObject) {

            [_dataSource removeAllObjects];
            [_rightView removeFromSuperview];
        
          [SVProgressHUD dismiss];
           int status = [[[responseObject objectForKey:@"code"] description] intValue];
           NSString *message = [[responseObject objectForKey:@"message"] description];
            if (status == 1) {
            self.countArray = [responseObject objectForKey:@"count"];
//                NSMutableArray *array = (NSMutableArray * )responseObject[@"count"];        
//                self.countArray = [array mutableCopy];
                
                for (int i = 0; i < self.countArray.count; i++) {
                    if (i == 3) {
                        for (NSDictionary * item in self.countArray[i]) {
                            [[self.countArray[2] mutableCopy] addObject:item];
                            
                        }
                    }
                    // @"迟到", @"旷工", @"早退", @"缺卡, @"外勤"
                    if (i == 2 || i == 4 || i == 5 || i == 6 || i == 11 )  {
                        [self.dataSource addObject:self.countArray[i]];
                    }
                }
                [self createUIWithData];
                [_tableView reloadData];
            }else {
                [self.superCheckController sendErrorWarning:message];
            }

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [self.superCheckController sendErrorWarning:error.localizedDescription];
        [SVProgressHUD dismiss];
    }];
    
   
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_dateBtn.frame)+2, self.backImageV.width, self.backImageV.height-self.dateBtn.height-2) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 34;
    [self.backImageV addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineKaoqinTableViewCell * cell = [MineKaoqinTableViewCell sharedMineKaoqinTableViewCell:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.dateLabel.text = _dataSource[indexPath.section][indexPath.row][@"time"];
    NSString * timeText = [NSString stringWithFormat:@"%@", _dataSource[indexPath.section][indexPath.row][@"mark"]];
    if (indexPath.section == 0 || indexPath.section == 2) {
        [cell.timeLabel setHidden:NO];
        cell.timeLabel.text = timeText;
    }else {
        [cell.timeLabel setHidden:YES];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray * titleArray = @[@"迟到", @"旷工", @"早退", @"缺卡", @"外勤"];
    NSArray * imageArray = @[@"mineChidao_Image",@"mineChidao_Image", @"mineChidao_Image", @"mineChidao_Image", @"mineWaiqin_Image"];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UIImageView * iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 20, 20)];
    iconV.image = [UIImage imageNamed:imageArray[section]];
    [view addSubview:iconV];
    UILabel *grayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 31, 0.5, 44)];
    grayLabel.backgroundColor = RGBACOLOR(196, 196, 196, 1);
    [view addSubview:grayLabel];
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconV.frame)+10, 0, 100, 44)];
    title.text = titleArray[section];
    [view addSubview:title];
    
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

@end
