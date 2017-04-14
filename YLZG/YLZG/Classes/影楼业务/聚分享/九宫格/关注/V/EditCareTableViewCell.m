//
//  EditCareTableViewCell.m
//  YLZG
//
//  Created by Chan_Sir on 2016/12/6.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "EditCareTableViewCell.h"
#import <Masonry.h>

@interface EditCareTableViewCell ()

@property (strong,nonatomic) UIImageView *selectImageV;

@end

@implementation EditCareTableViewCell

+ (instancetype)sharedEditCareCell:(UITableView *)tableView
{
    static NSString *ID = @"EditCareTableViewCell";
    EditCareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EditCareTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}


- (void)setCareModel:(CareMobanModel *)careModel
{
    _careModel = careModel;
    if (careModel.status) {
        _selectImageV.image = [UIImage imageNamed:@"EditControlSelected"];
    }else{
        _selectImageV.image = [UIImage imageNamed:@"EditControl"];
    }
    self.textLabel.text = careModel.name;
    
}
- (void)setupSubViews
{
    self.selectImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"EditControl"]];
    [self.contentView addSubview:self.selectImageV];
    [self.selectImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.width.and.height.equalTo(@24);
    }];
    
}

@end
