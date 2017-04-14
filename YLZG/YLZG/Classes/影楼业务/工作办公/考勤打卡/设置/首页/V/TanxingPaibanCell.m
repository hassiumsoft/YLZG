//
//  TanxingPaibanCell.m
//  NewHXDemo
//
//  Created by Chan_Sir on 16/7/4.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "TanxingPaibanCell.h"
#import "SubTitleView.h"
#import "BanciButton.h"
#import "DetialBanciModel.h"
#import <MJExtension.h>
#import <Masonry.h>


#define marginNum 1


@interface TanxingPaibanCell ()

/** ？？？？ */
@property (strong,nonatomic) UIButton *button;
/** 装着7个按钮 */
@property (strong,nonatomic) NSMutableArray *buttonArr;
/** 名字 */
@property (strong,nonatomic) UILabel *nameLabel;

/** 装着classid,classname,date的数组 */
@property (strong,nonatomic) NSMutableArray *detialModelArray;
@property (strong,nonatomic) NSMutableArray *detialDicArray;


@end

@implementation TanxingPaibanCell

+ (instancetype)shatedTanxingPaibanCell:(UITableView *)tableView MemModel:(StaffInfoModel *)memModel BanciModel:(BanciModel *)banciModel DateArray:(NSArray *)dateArray
{
    static NSString *ID = @"TanxingPaibanCell";
    TanxingPaibanCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TanxingPaibanCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}
- (void)setMemModel:(StaffInfoModel *)memModel
{
    _memModel = memModel;
    _nameLabel.text = memModel.nickname;
    
}
- (void)setBanciModel:(BanciModel *)banciModel
{
    _banciModel = banciModel;
}
- (void)setDateArray:(NSArray *)dateArray
{
    _dateArray = dateArray;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [YLNotificationCenter addObserver:self selector:@selector(paibanciChanged:) name:KQPaibanciChanged object:nil];
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        self.backgroundColor = NorMalBackGroudColor;
        [self setupSubViews];
    }
    return self;
}

- (void)paibanciChanged:(NSNotification *)noti
{
    self.banciModel = noti.object;
}

- (void)setupSubViews
{
    // 名字
    CGFloat topBtnW = (SCREEN_WIDTH - 7)/8;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, topBtnW, 48)];
    self.nameLabel.backgroundColor = [UIColor whiteColor];
//    self.nameLabel.font = [UIFont systemFontOfSize:14*CKproportion];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nameLabel];
    
    
    CGRect frame;
    CGFloat Kuan = (SCREEN_WIDTH - topBtnW - 6 * marginNum)/7;
    for (int i = 0; i < 7; i++) {
        
        frame.origin.x = (i%7) * (topBtnW + marginNum) + marginNum + marginNum + topBtnW;
        frame.origin.y = 1;
        frame.size.width = Kuan;
        frame.size.height = 47;
        
        BanciButton *button = [BanciButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 1; // 未来7天
        button.date = self.dateArray[i];
        [button addTarget:self action:@selector(kkkkkk:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [button setFrame:frame];
        [self addSubview:button];
        
        [self.buttonArr addObject:button];
    }
    
    // 线
    UIView *xian = [[UIView alloc]init];
    xian.backgroundColor = [UIColor whiteColor];
    [self addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.height.equalTo(@1);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
}
#pragma mark - 点击回调
- (void)kkkkkk:(BanciButton *)sender
{
    if (sender.detialBanciModel.isSelected) {  // 暂时不让修改
        return;
    }
    
    [sender setTitle:self.banciModel.classname forState:UIControlStateNormal];
    
    sender.detialBanciModel.date = self.dateArray[sender.tag - 1];
    sender.detialBanciModel.classid = self.banciModel.classid;
    sender.detialBanciModel.classname = self.banciModel.classname;
    sender.detialBanciModel.isSelected = YES;
    sender.detialBanciModel.start = self.banciModel.start;
    sender.detialBanciModel.end = self.banciModel.end;
    
    
    if (self.detialModelArray.count == 0) {
        [self.detialModelArray addObject:sender.detialBanciModel]; // 需要过滤
        [self.detialDicArray addObject:[sender.detialBanciModel mj_keyValues]];
    }else{
        
        [self.detialModelArray addObject:sender.detialBanciModel];
        [self.detialDicArray addObject:[sender.detialBanciModel mj_keyValues]];
        
//        for (int i = 0; i < self.detialModelArray.count; i++) {
//            DetialBanciModel *banciDetial = self.detialModelArray[i];
//            if ([sender.detialBanciModel.date isEqualToString:banciDetial.date]){
//                // 这个日期的班次已更改，替换旧的
//                [self.detialModelArray replaceObjectAtIndex:i withObject:sender.detialBanciModel];
//                [self.detialDicArray replaceObjectAtIndex:i withObject:[sender.detialBanciModel mj_keyValues]];
//            }else{ // 日期不一样
//                // 有问题，不该直接添加。判断ID、name、date
//                
//                [self.detialModelArray addObject:sender.detialBanciModel];
//                [self.detialDicArray addObject:[sender.detialBanciModel mj_keyValues]];
//                
//            }
//        }
    }
    
    
//    self.bigDict[@"identifier"] = [NSString stringWithFormat:@"%@_%@",self.memModel.uid,self.dateArray[sender.tag - 1]];
    self.bigDict[@"nickname"] = self.memModel.nickname;
    self.bigDict[@"realname"] = self.memModel.realname;
    self.bigDict[@"uid"] = self.memModel.uid;
    self.bigDict[@"username"] = self.memModel.username;
    self.bigDict[@"detial"] = self.detialDicArray; // dictArray
    
//    NSDictionary *dict = self.bigDict;
    
    if (self.detialDicArray.count == 7) {
        if ([self.delegate respondsToSelector:@selector(tanxingPaibanWithRulesDict:)]) {
            [self.delegate tanxingPaibanWithRulesDict:self.bigDict];
        }
    }else{
        KGLog(@"%@",self.detialDicArray);
        KGLog(@"请完善改员工一周上班时间");
    }
    
    
}

#pragma mark - 懒加载

- (NSMutableArray *)buttonArr
{
    if (!_buttonArr) {
        _buttonArr = [[NSMutableArray alloc]init];
    }
    return _buttonArr;
}
- (NSMutableDictionary *)bigDict
{
    if (!_bigDict) {
        _bigDict = [[NSMutableDictionary alloc]init];
    }
    return _bigDict;
}
- (NSMutableArray *)detialModelArray
{
    if (!_detialModelArray) {
        _detialModelArray = [[NSMutableArray alloc]init];
    }
    return _detialModelArray;
}
- (NSMutableArray *)detialDicArray
{
    if (!_detialDicArray) {
        _detialDicArray = [[NSMutableArray alloc]init];
    }
    return _detialDicArray;
}

@end
