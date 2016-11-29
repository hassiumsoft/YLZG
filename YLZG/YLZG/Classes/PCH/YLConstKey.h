//
//  YLConstKey.h
//  影楼掌柜
//
//  Created by Chan_Sir on 16/6/21.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**************** 专门存放缓存、通知等键值的类 ****************/

/************  通知及监听 关键字  *****************/

#define YLNotificationCenter [NSNotificationCenter defaultCenter]

/** 除移选择器 */
extern NSString *const YLRemovePickerView;
/** 签到时间 */
extern NSString *const YLQiaodaoTime;
/** 选取日期 */
extern NSString *const YLDatePicker;
/** removeDatePickerV */
extern NSString *const YLRemoveDatePickerV;
/** 传递预约时间 */
extern NSString *const YLPickerTime;
/** 发布公告后通知前VC刷新数据 */
extern NSString *const YLRequestData;
/** 摄控本传递Type给父类VC */
extern NSString *const YLTypeObject;
/** 待审批里的刷新数据 */
extern NSString *const YLReloadShenpiData;
/** 财务统计监听日期月份 */
extern NSString *const YLCaiwuChangeDate;
/** 改昵称了 */
extern NSString *const YLNickNameChanged;
/** 改头像了 */
extern NSString *const YLHeadImageChanged;
/** 除移蒙蒙图层 */
extern NSString *const YLRemoveMengBtn;
/** 传递请假的类型 */
extern NSString *const YLQingjiaType;
/** 没有数据时除移原先业绩榜视图 */
extern NSString *const YLRemoveYejiTableView;
/** 查询名字 */
extern NSString *const YLChaxunMingzi;
/** 订单保存成功之后的提示 */
extern NSString *const YLOffLineOrderAlert;
/** 传递type */
extern NSString *const YLaccount_type;
/** 选择城市 */
extern NSString *const YLCityDidChangeNotification;
/** 选中的城市 */
extern NSString *const YLSelectCityName;
/** 定位到的城市 */
extern NSString *const FYLocationCity;
/** 用户"首次登陆"判断 */
extern NSString *const isFirst;
/** 离线订单的本地通知 */
extern NSString *const YLLocalNotiOfflineOrder;
/** 退出环信登录 */
extern NSString *const HXReturnAccount;
/** 上班时间 */
extern NSString *const StartWorkTime;
/** 下班时间 */
extern NSString *const EndWorkTime;
/** 排班制切换班次 */
extern NSString *const KQPaibanciChanged;
/** 考勤高级设置时间通知 */
extern NSString *const KaoqinSettingNoti;
/** 任务列表刷新数据 */
extern NSString *const TaskReloadData;

/************** 环信SDK里的通知键值 **************/

/** 通知通讯录界面刷新数据 */
extern NSString *const HXUpdataContacts;
/** 没有消息了，红点消失吧 */
extern NSString *const HXSetupUntreatedApplyCount;
extern NSString *const HXSetupUnreadMessageCount;
/** 视频通话信息 */
extern NSString *const HXShowCallInfo;
/** 除移全部消息记录 */
extern NSString *const HXRemoveAllMessages;
/** 离开群组通知 */
extern NSString *const HXExitGroup;
/** 退到主界面，再push到聊天界面 */
extern NSString *const HXRePushToChat;
/** 呼出网络电话 */
extern NSString *const HXCallOutPhoneChatter;
/** 更新群组信息 */
extern NSString *const HXUpdataGroupInfo;






/************* NSUserDefault 关键字 **************/

#define USER_DEFAULT [NSUserDefaults standardUserDefaults];

extern NSString *const UDRedComponent; // 存储主题切换时的R色值
extern NSString *const UDGreenComponent; // 存储主题切换时的G色值
extern NSString *const UDBlueComponent; // 存储主题切换时的B色值
extern NSString *const CFBundleVersion; // 第一次进来展示引导页
extern NSString *const UDUnApplyCount; // 未处理的好友请求
extern NSString *const UDLoginUserName; // 登录名缓存

/************** 其他键值 *************/

/** 发帖弹出vc-减去宽度*/
extern CGFloat const FatieAnimationWidthMinus;
/** 发帖弹出vc-减去高度*/
extern CGFloat const FatieAnimationHeightMinus;

NS_ASSUME_NONNULL_END

