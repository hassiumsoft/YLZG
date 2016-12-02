//
//  ProduceDetialFileCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/11/23.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "ProduceDetialFileCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>


@interface ProduceDetialFileCell ()

/** 上传者头像 */
@property (strong,nonatomic) UIImageView *uploadHeadV;
/** 上传者昵称 */
@property (strong,nonatomic) UILabel *nameLabel;
/** 文件塑料图 */

/** 上传于···时间 */
@property (strong,nonatomic) UILabel *timeLabel;

@end

@implementation ProduceDetialFileCell

+ (instancetype)sharedProduceDetialFileCell:(UITableView *)tableView
{
    static NSString *ID = @"ProduceDetialFileCell";
    ProduceDetialFileCell *CELL = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!CELL) {
        CELL = [[ProduceDetialFileCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return CELL;
}
- (void)setFileModel:(ProduceFileModel *)fileModel
{
    _fileModel = fileModel;
    [_uploadHeadV sd_setImageWithURL:[NSURL URLWithString:fileModel.head] placeholderImage:[UIImage imageNamed:@"user_place"]];
    _nameLabel.text = fileModel.nickname;
    NSString *time = [self timeIntervalToDate:fileModel.upload_at];
    _timeLabel.text = [NSString stringWithFormat:@"%@上传于%@",fileModel.nickname,time];
    if (fileModel.type == 1) {
        // 附件类型是图片
        [self createFujianView:fileModel];
    }else if (fileModel.type == 2){
        // 附件类型是文件
        [self createFujianView:fileModel];
    }else{
        
    }
}

- (void)createFujianView:(ProduceFileModel *)disModel
{
    if (disModel.type == 1) {
        // 附件是图片
        UIImageView *disImageView = [[UIImageView alloc]init];
        disImageView.userInteractionEnabled = YES;
        [disImageView sd_setImageWithURL:[NSURL URLWithString:disModel.thumb] placeholderImage:[UIImage imageNamed:@"task_image_place"]];
        [self addSubview:disImageView];
        [disImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX).offset(-10);
            make.top.equalTo(self.uploadHeadV.mas_bottom);
            make.width.equalTo(@80);
            make.height.equalTo(@80);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if (self.DidBlock) {
                _DidBlock(disModel.type);
            }
        }];
        [disImageView addGestureRecognizer:tap];
        
        // 图片名称
        UILabel *fileNameL = [[UILabel alloc]init];
        fileNameL.text = disModel.name;
        fileNameL.textColor = [UIColor grayColor];
        fileNameL.font = [UIFont systemFontOfSize:12];
        [self addSubview:fileNameL];
        [fileNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(disImageView.mas_right).offset(5);
            make.bottom.equalTo(disImageView.mas_bottom);
            make.height.equalTo(@21);
        }];
    }else{
        // 附件是文件类型
        UIImageView *disFileView = [[UIImageView alloc]init];
        disFileView.userInteractionEnabled = YES;
        [disFileView sd_setImageWithURL:[NSURL URLWithString:disModel.thumb] placeholderImage:[UIImage imageNamed:@"task_file_place"]];
        [self addSubview:disFileView];
        [disFileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX).offset(-10);
            make.top.equalTo(self.uploadHeadV.mas_bottom);
            make.width.equalTo(@80);
            make.height.equalTo(@80);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            if (self.DidBlock) {
                _DidBlock(disModel.type);
            }
        }];
        [disFileView addGestureRecognizer:tap];
        
        // 文件名称
        UILabel *fileNameL = [[UILabel alloc]init];
        fileNameL.text = disModel.name;
        fileNameL.textColor = [UIColor grayColor];
        fileNameL.font = [UIFont systemFontOfSize:12];
        [self addSubview:fileNameL];
        [fileNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(disFileView.mas_right).offset(5);
            make.bottom.equalTo(disFileView.mas_bottom);
            make.height.equalTo(@21);
        }];
        
    }
    
}

- (NSString *)timeIntervalToDate:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *origanStr = [NSString stringWithFormat:@"%@",date];
    NSString *time = [origanStr substringWithRange:NSMakeRange(5, 11)];
    return time;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    // 上传者头像
    self.uploadHeadV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 40, 40)];
    self.uploadHeadV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.uploadHeadV];
    // 上传者昵称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.uploadHeadV.frame) + 5, 10, 150, 21)];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLabel];
    
    // 上传时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@21);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
    }];
}

@end
