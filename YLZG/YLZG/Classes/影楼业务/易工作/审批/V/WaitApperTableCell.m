//
//  WaitApperTableCell.m
//  ChatDemo-UI3.0
//
//  Created by Chan_Sir on 16/4/21.
//  Copyright © 2016年 Chan_Sir. All rights reserved.
//

#import "WaitApperTableCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>


@interface WaitApperTableCell ()

/** 申请人头像 */
@property (strong,nonatomic) UIImageView *headImageV;
/** xxx的请假申请 */
@property (strong,nonatomic) UILabel *descLabel;
/** 审批状态 */
@property (strong,nonatomic) UILabel *apperState;
/** 时间 */
@property (strong,nonatomic) UILabel *timeLabel;

@end

@implementation WaitApperTableCell


+ (instancetype)sharedWaitApperTableCell:(UITableView *)tableView
{
    static NSString *ID = @"WaitApperTableCell";
    WaitApperTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (!cell) {
        cell = [[WaitApperTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setModel:(ApproveModel *)model
{
    _model = model;
    
    
    switch (model.kind) {
        case 1:
        {
            // 通用审批
            _descLabel.text = [NSString stringWithFormat:@"%@的其他申请",model.sply_nickname];
            break;
        }
        case 2:
        {
            // 请假
            _descLabel.text = [NSString stringWithFormat:@"%@的请假申请",model.sply_nickname];
            
            break;
        }
        case 3:
        {
            // 外出
            _descLabel.text = [NSString stringWithFormat:@"%@的外出申请",model.sply_nickname];
            break;
        }
        case 4:
        {
            // 物品领用
            _descLabel.text = [NSString stringWithFormat:@"%@的物品领用通知",model.sply_nickname];
            break;
        }
        default:
            break;
    }
    
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.sply_head]] placeholderImage:[self imageWithBgColor:HWRandomColor]];
    NSString * time = [self TimeIntToDateStr:model.sply_time];
    _timeLabel.text = time;
    
    KGLog(@"model.status = %ld",(long)model.status);
    
    if (model.status == 1) {
        self.apperState.textColor = RGBACOLOR(43, 171, 63, 1);
        self.apperState.text = @"已审批";
        
    }else if(model.status == 0){
        self.apperState.textColor =  RGBACOLOR(251, 168, 41, 1);
        self.apperState.text = @"待审批";
    }else{
        self.apperState.textColor =  [UIColor redColor];
        self.apperState.text = @"申请未通过";
    }
}

- (NSString *)TimeIntToDateStr:(NSTimeInterval)timeInterval {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIImageView *xian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@2);
    }];
    
    self.headImageV = [[UIImageView alloc]init];
    self.headImageV.layer.masksToBounds = YES;
    self.headImageV.layer.cornerRadius = 6;
    [self addSubview:self.headImageV];
    [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.and.height.equalTo(@45);
    }];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.text = @"XXX的请假申请";
    self.descLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageV.mas_top).offset(5);
        make.height.equalTo(@21);
        make.left.equalTo(self.headImageV.mas_right).offset(20);
    }];
    
    self.apperState = [[UILabel alloc]init];
    self.apperState.text = @"待审批";
    self.apperState.textColor = [UIColor orangeColor];
    self.apperState.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [self addSubview:self.apperState];
    [self.apperState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageV.mas_bottom);
        make.left.equalTo(self.descLabel.mas_left);
        make.height.equalTo(@22);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.text = @"283u83u39292";
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageV.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@22);
    }];
    
}


- (UIImage *)imageWithBgColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


@end
