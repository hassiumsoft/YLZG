//
//  PCH_HTTP_URL.h
//  PhotoManager
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#ifndef PCH_HTTP_URL_h
#define PCH_HTTP_URL_h


#define Base_URL @"http://zsylou.wxwkf.com"

// 登录接口
#define YLLoginURL @"http://192.168.0.184/index.php/home/login/login?username=%@&password=%@&sn=%@"
// 上传头像
#define UploadHeadUTL @"http://192.168.0.184/index.php/home/contacts/upload_avatar?uid=%@"
// 修改昵称
#define UploadNickNameURL @"http://192.168.0.184/index.php/home/contacts/update?nickname=%@&uid=%@"
// 修改电话号码
#define UploadMobieURL @"http://192.168.0.184/index.php/home/contacts/update?mobile=%@&uid=%@"
// 修改生日
#define UploadBirthURL @"http://192.168.0.184/index.php/home/contacts/update?birth=%@&uid=%@"
// 修改密码
#define UploadPassWordURL @"http://192.168.0.184/index.php/home/ModifyPwd/modify?oldpwd=%@&newpwd=%@&uid=%@"
// 意见反馈
#define MySuggestURL @"http://192.168.0.184/index.php/home/FeedBack/suggest?uid=%@&type=%d&content=%@&phone=%@"

// 查询
#define SEARCH_URL @"http://192.168.0.184/index.php/home/query/index?detail=%@&uid=%@"
// 查询的详情列表
#define SEARCHDEATIL_URL @"http://192.168.0.184/index.php/home/query/detail?id=%@&uid=%@"
// 订单进度
#define SearchOrderProgress_Url @"http://192.168.0.184/index.php/home/query/status?guest=%@&phone=%@&uid=%@"

//  签到
#define Qiaodao_URl @"http://192.168.0.184/index.php/home/checkin/index?x=%f&y=%f&location=%@&uid=%@"
// 签到查询
#define QiaodaoSearch_URL @"http://192.168.0.184/index.php/home/checkin/query?uid=%@"

//  发布公告
#define FabuGonggao @"http://192.168.0.184/index.php/home/bbs/publish?title=%@&content=%@&type=1&top=%d&uid=%@"

//  查询公告
#define QueryGongao @"http://192.168.0.184/index.php/home/bbs/query?uid=%@"

//  申请请假
#define Qingjia @"http://192.168.0.184/index.php/home/leave/ask?start=%@&finish=%@&days=%@&reason=%@&type=%@&approver=%@&uid=%@"

//  外出申请
#define Waichu_URL @"http://192.168.0.184/index.php/home/outgoing/appro?start=%@&finish=%@&longtime=%@&reason=%@&type=%@&approver=%@&uid=%@"

//  物品领用

#define Wupinlingyong_Url @"http://192.168.0.184/index.php/home/consuming/sply?usages=%@&items=%@&nums=%@&details=%@&approver=%@&uid=%@"

// 12.通用审批 标题 title  内容 content  审批人 approver  192.168.0.199/index.php/home/sply/appro?title=通用测试&content=测试内容&approver=1&uid=2
#define TongyongShenpi @"http://192.168.0.184/index.php/home/sply/appro?title=%@&content=%@&approver=%@&uid=%@"

// 13.审批的三个内页
//“我发起的”查询：
#define ShenpiStart_URL @"http://192.168.0.184/index.php/home/approve/myappro?uid=%@"
//“待我审批”查询：
#define ShenpiWait_URL @"http://192.168.0.184/index.php/home/approve/unappro?uid=%@"
//“我已审批”查询：
#define ShenpiAlready_URL @"http://192.168.0.184/index.php/home/approve/approed?uid=%@"
//单个审批详情查询：
#define ShenpiWaitDeatil_URL @"http://192.168.0.184/index.php/home/approve/query?id=%@&kind=%d&uid=%@"
//审批意见（同意还是拒绝）
#define shenpiSuggest @"http://192.168.0.184/index.php/home/approve/approve?id=%@&kind=%d&opinion=%@&details=%@&uid=%@"
// 联系人头像、昵称、手机号、生日修改接口：
#define ConnectPerson_Url @"http://192.168.0.184/index.php/home/contacts/update?mobile=%@&head=%@&nickname=%@&birth=%@&uid=%@"
// 今日财务
#define Financial_Url @"http://192.168.0.184/index.php/home/todayfinance/query?date=%@&uid=%@"
// 查询套系名称及价格
#define SearchTaoxi_URL @"http://192.168.0.184/index.php/home/set/query_set?uid=%@"
// 业绩榜URL
#define YejiURL @"http://192.168.0.184/index.php/home/record/query?date=%@&uid=%@"
// 预约接口
#define Yuyue_URL @"http://192.168.0.184/index.php/home/order/order_id/?tradeid=%@&type=%d&date=%@&time=%@&uid=%@"

// 摄控本
/** 参数：日期 date  查询类目 type  （均可为空，为空时默认查询当日，拍照的信息） 查询类目 type 可选值  0拍照  ， 1选片   2看样   3取件 */
#define Shekongben_Url @"http://192.168.0.184/index.php/home/skb/query?date=%@&type=%d&uid=%@"

// 19.摄控本日历
/**
 参数: date 统计起始日期  date2 统计结束日期  type 查询类目 (type 可选值  0拍照  ， 1选片   2看样   3取件)
 参数 "均可为空" ,为空时默认查询今日到之后30天的统计数据
 返回值为多维数组, 字段 type  类目   num 预约量  date 日期
 */
#define ShekongRili_Url @"http://192.168.0.184/index.php/home/skb/query_section?uid=%@&date=%@&date2=%@&type=%d"

//  我的工作
#define MyWork_Url @"http://192.168.0.184/index.php/home/mywork/mywork?date=%@&uid=%@"

//  今日订单
#define TodayOrder_Url @"http://192.168.0.184/index.php/home/todaytrade/query?date=%@&uid=%@"
//  获取套系下的产品
#define TaoxiProduct_Url @"http://192.168.0.184/index.php/home/SetProducts/query_set_products?name=%@&uid=%@"
//  获取所有产品
#define AllTaoxiProduct_Url @"http://192.168.0.184/index.php/home/products/query?type=name=&uid=%@"
//  查询景点
#define SearchSpot_Url @"http://192.168.0.184/index.php/home/spot/query?uid=%@"

// 新的开单接口
#define OpenOrder_Url_New @"http://192.168.0.184/index.php/home/newtrade/newtrade?uid=%@&price=%@&set=%@&guest=%@&msg=%@&mobile=%@&productlist=%@&spot=%@&negative=%@&album=%@&category=%@&source=%@&number=%@&guest2=%@&mobile2=%@"
// 套系类别
#define TaoxiType_URL @"http://192.168.0.184/index.php/home/Category/query?uid=%@"
// 客户来源
#define CusTomer_URL @"http://192.168.0.184/index.php/home/customerSource/query?uid=%@"
// 会员卡号 info : 姓名、手机、会员卡号
#define CardNum_URL @"http://192.168.0.184/index.php/home/member/query?uid=%@&info=%@"

//  小红色求的显示(获取未读取数据(极光推送))(返回三组action和type   第一组是公告 ，第二组是待我审批 ，第三组是我发起的申请 )
#define IsReady_Url @"http://192.168.0.184/index.php/home/IosIsRead/query_all_unread?uid=%@"

/** 修改接口.已读之后就把数据返回给后台,告诉此消息已读(参数 action  type  （ action:  1 公告  2 审批 type: 审批项目:  1 待我审批 , 2 我发起的 ）
 如果没有要修改为已读的消息 ，action 和type为空即可)*/
#define AlreadyReady_Url @"http://192.168.0.184/index.php/home/IosIsRead/isreaded?uid=%@&action=%@&type=%@"

//  影楼之家
#define YLHome_Url @"http://192.168.0.184/index.php/home/contacts/query?uid=%@"
// 根据某个ID查询用户信息
#define SearchUserInfo_URL @"http://192.168.0.184/index.php/home/easemob/get_user_info?uid=%@&name=%@"
// 我的影楼H5界面
#define MyStido_Url @"http://192.168.0.184/index.php/home/MyYLou/query?uid=%@"
// 联系区域经理
#define ContactManager_Url @"http://192.168.0.184/index.php/home/MarketManager/query?uid=%@"
// 分享链接
#define Share_URL @"http://192.168.0.184/index.php/home/ShareUrl/geturl?uid=%@"
//  版本更新
#define VersionUpdate_Url @"http://192.168.0.184/index.php/home/version/query?os=2"

//  引导页
#define LeadPage_Url @"http://192.168.0.184/index.php/home/CoverImg/query?uid=%@"

//  查询店铺所有员工的签到统计（次数）信息接口 (date 日期（可选)）
#define AllQianDao_URL @"http://192.168.0.184/index.php/home/checkin/query_all_times?date=%@&uid=%@"

//  查询某一个员工的签到详细信息
#define AllQianDaoDetail_URL @"http://192.168.0.184/index.php/home/checkin/query_the_one?id=%@&date=%@&uid=%@"

//  新增考勤组
#define CreateKaoqunGroup_Url @"http://192.168.0.184/index.php/home/attence/new_attence_group"

//  查询所有考勤组（返回具有管理权限的考勤组）
#define SearchKaoqunGroup_Url @"http://192.168.0.184/index.php/home/attence/list_attence_group?uid=%@"

//  删除考勤组
#define DeleteKaoqinzu_Url @"http://192.168.0.184/index.php/home/attence/del_attence_group?uid=%@&gid=%@"
//  查询所有考勤班次
#define AllBanci_Url @"http://192.168.0.184/index.php/home/attence/list_attence_class?uid=%@"
//  新增班次
#define AddNewBanci_Url @"http://192.168.0.184/index.php/home/attence/new_attence_class?uid=%@&start=%@&end=%@"
//  删除某个全局班次
#define DeleteOneBanci_Url @"http://192.168.0.184/index.php/home/attence/del_attence_class?uid=%@&aid=%@"

//  查询员工当日的考勤规则接口(服务器给返回来的数据)
#define QiandaoDakaAll_Url  @"http://192.168.0.184/index.php/home/attence/get_user_rule?uid=%@"

//  打卡成功传给服务器数据的接口
#define QiandaoDakaChenggong_Url @"http://192.168.0.184/index.php/home/attence/checkin?uid=%@&type=%@&id=%@&time=%@&router=%@&location=%@&status=%@&outside=%@&remark=%@"
//  统计中我的考勤
#define Count_MyKaoqin_Url @"http://192.168.0.184/index.php/home/attence/user_count_checkin?uid=%@&month=%@"
//  团队考勤
#define TeamKaoqin_Url @"http://192.168.0.184/index.php/home/attence/group_count_checkin?uid=%@&date=%@"

//  统计中团队考勤
#define Count_TeamKaoqin_Url @"http://192.168.0.184/index.php/home/attence/group_count_checkin?uid=%@&date=%@"
//  查询订单收款的二维码
#define ErweimaImage_Url @"http://192.168.0.184/index.php/home/PayCode/query?uid=%@&type=%@"
//  订单支付完成后的操作
#define FinishedPayOrder_Url @"http://192.168.0.184/index.php/home/PayTrade/pay?uid=%@&type=%d&money=%@&trade_id=%@"
//  查询考勤组高级设置
#define SuperSet_Url @"http://192.168.0.184/index.php/home/attence/query_whole?uid=%@"
//  考勤高级设置
#define GaojiSetting_Url @"http://192.168.0.184/index.php/home/attence/update_whole?uid=%@&privilege_time=%@&latetime=%@&absent=%@&ontip=%@&offtip=%@&earlytime=%@&outtip=%d&sply=%d"
//  查询某成员是否已在某成员组
#define IsInSomeGroup_Url @"http://192.168.0.184/index.php/home/attence/check_is_in_group?uid=%@"

// 获取通讯录数据
#define ContactList_Url @"http://192.168.0.184/index.php/home/easemob/my_contacts?uid=%@"
// 群组成员
#define GroupMember_URL @"http://192.168.0.184/index.php/home/easemob/get_group_users_list?uid=%@&gid=%@"

// 营销工具列表
#define YingxiaoToolList_URL @"http://192.168.0.184/index.php/home/tool/lists?uid=%@"
// 工具详细说明
#define YingxiaoToolDetial_URL @"http://192.168.0.184/index.php/home/tool/content?uid=%@&id=%@"
// 工具-H5页面
#define YingxiaoToolHTM5_URL @"http://192.168.0.184/index.php/home/tool/show?uid=%@&id=%@"


// 任务--项目列表
#define TaskProductList_URL @"http://192.168.0.184/index.php/home/project/lists?uid=%@"
// 任务--创建项目
#define CreateProduce_URL @"http://192.168.0.184/index.php/home/project/create?uid=%@&name=%@&member=%@"
// 项目详情
#define ProduceDetial_URL @"http://192.168.0.184/index.php/home/project/detail?uid=%@&id=%@"
// 删除任务里的项目
#define DeleteTaskProduce_Url @"http://192.168.0.184/index.php/home/project/delete?uid=%@&id=%@"
// 创建新任务
#define CreateNewTask_Url @"http://192.168.0.184m/index.php/home/task/create?uid=%@&pid=%@&name=%@&manager=%@&deadline=%@&check=%@&care=%@&description=%@"
// 任务-任务列表
#define TaskList_Url @"http://192.168.0.184/index.php/home/task/lists?uid=%@"
// 任务-详细信息
#define TaskDetial_Url @"http://192.168.0.184/index.php/home/task/detail?uid=%@&id=%@"
// 任务--修改任务状态
#define UpdateTaskStatus_Url @"http://192.168.0.184/index.php/home/task/update?uid=%@&pid=%@&id=%@&status=%d"
// 任务--修改任务名称
#define UpdateTaskName_Url @"http://192.168.0.184/index.php/home/task/update?uid=%@&pid=%@&id=%@&name=%@"
// 任务--修改任务负责人
#define UpdateTaskFuzer_Url @"http://192.168.0.184/index.php/home/task/update?uid=%@&pid=%@&id=%@&manager=%@"
// 任务--修改任务截止日期
#define UpdateTaskDate_Url @"http://192.168.0.184/index.php/home/task/update?uid=%@&pid=%@&id=%@&deadline=%@"
// 任务--关注或取消关注任务
#define CareOrNotCareTask_URL @"http://192.168.0.184/index.php/home/task/update?uid=%@&pid=%@&id=%@&icare=%d"
// 任务--删除任务
#define DeleteTask_URL @"http://192.168.0.184/index.php/home/task/delete?uid=%@&pid=%@&id=%@"
// 任务--已完成的任务
#define TaskFinished_URL @"http://192.168.0.184/index.php/home/task/done?uid=%@&type=%d&page=%d&num=%d"
// 任务--任务动态
#define TaskDongtai_Url @"http://192.168.0.184/index.php/home/dynamic/lists?uid=%@&date=%@"
// 任务--发布文字评论
#define TaskSendContent_Url @"http://192.168.0.184/index.php/home/discuss/onlyText?uid=%@&pid=%@&type=%d&item=%@&content=%@"


// 九宫格--全部模板
#define NineList_Url @"http://192.168.0.184/index.php/wei/retransmission/index?uid=%@"
// 九宫格--搜索模板
#define NineSearch_Url @"http://192.168.0.184/index.php/wei/retransmission/search?uid=%@&keyword=%@"
// 九宫格--分类模板
#define NineCategory_Url @"http://192.168.0.184/index.php/wei/retransmission/lists?uid=%@&id=%@&page=%d&nums=%d"
// 九宫格--关注列表
#define NineCareList_Url @"http://192.168.0.184/index.php/wei/retransmission/myCare?uid=%@"
// 九宫格--编辑关注模本分类
#define NineCareEdit_Url @"http://192.168.0.184/index.php/wei/retransmission/updateCareCate?uid=%@&care=%@"
// 九宫格--团队已经使用
#define NineTeamUsed_Url @"http://192.168.0.184/index.php/wei/retransmission/groupRetrans?uid=%@&date=%@"
// 九宫格--我已经使用
#define NineMyUsed_Url @"http://192.168.0.184/index.php/wei/retransmission/myRetrans?uid=%@&date=%@"
// 九宫格--模板详情
#define NineDetial_Url @"http://192.168.0.184/index.php/wei/retransmission/detail?uid=%@&id=%@&date=%@"
// 九宫格--转发提醒
#define NineResendTips_Url @"http://192.168.0.184/index.php/wei/retransmission/retransRemind?uid=%@&id=%@"
// 九宫格--上传模板
#define UpLoadMoban_Url @"http://192.168.0.184/index.php/wei/retransmission/create"
// 九宫格--删除我的模板
#define DeleteMyMoban_Url @"http://192.168.0.184/index.php/wei/retransmission/delete?uid=%@&id=%@"
// 九宫格--获取团队制作的分类
#define TeamClasses_Url @"http://192.168.0.184/index.php/wei/retransmission/teamCategory?uid=%@"
// 九宫格--我的模板
#define GetMyMoban_Url @"http://192.168.0.184/index.php/wei/retransmission/myTemplet?uid=%@&date=%@"
// 九宫格--转发计数
#define ZhuanfaCount_Url @"http://192.168.0.184/index.php/wei/retransmission/retransTimes?uid=%@&id=%@&cid=%@"





#pragma mark - 须知
//1、请求格式使用HTTP/GET
//2、账户名和密码【czc1943 && 1 || ddc1 && 123456】
#pragma mark - 接口
//1.登录：
#define LOGIN_URL @"http://111.164.214.245:9999/pointAction.do?method=login&name=%@&passwd=%@"
//2.添加设备：
#define ADD_URL @"http://111.164.214.245:9999/bjltAddDevice.do?name=czc1943&passwd=1&imei=111111111111111&typeId=1"
//3.设备类型列表：www.gpssee.net:81
#define LIST_URL @"http://111.164.214.245:9999/pointAction.do?method=login&name=czc1943&passwd=1"
//4.设备追踪
#define FOLLOW_URL @"http://111.164.214.245:9999/pointAction.do?method=findLastPoint&imei=111111111111111"


#endif /* PCH_HTTP_URL_h */
