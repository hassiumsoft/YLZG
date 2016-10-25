//
//  PCH_HTTP_URL.h
//  PhotoManager
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#ifndef PCH_HTTP_URL_h
#define PCH_HTTP_URL_h

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


#define Base_URL @"http://zsylou.wxwkf.com/"

// 登录接口
#define YLLoginURL @"http://zsylou.wxwkf.com/index.php/home/login/login?username=%@&password=%@&sn=%@"

// 上传头像
#define UploadHeadUTL @"http://zsylou.wxwkf.com/index.php/home/contacts/upload_avatar?uid=%@"
// 修改昵称
#define UploadNickNameURL @"http://zsylou.wxwkf.com/index.php/home/contacts/update?nickname=%@&uid=%@"
// 修改电话号码
#define UploadMobieURL @"http://zsylou.wxwkf.com/index.php/home/contacts/update?mobile=%@&uid=%@"
// 修改生日
#define UploadBirthURL @"http://zsylou.wxwkf.com/index.php/home/contacts/update?birth=%@&uid=%@"
// 修改密码
#define UploadPassWordURL @"http://zsylou.wxwkf.com/index.php/home/ModifyPwd/modify?oldpwd=%@&newpwd=%@&uid=%@"
// 意见反馈
#define MySuggestURL @"http://zsylou.wxwkf.com/index.php/home/FeedBack/suggest?uid=%@&type=%d&content=%@&phone=%@"

//5.查询
#define SEARCH_URL @"http://zsylou.wxwkf.com/index.php/home/query/index?detail=%@&uid=%@"
// 查询的详情列表
#define SEARCHDEATIL_URL @"http://zsylou.wxwkf.com/index.php/home/query/detail?id=%@&uid=%@"
// 订单进度
#define SearchOrderProgress_Url @"http://zsylou.wxwkf.com/index.php/home/query/status?guest=%@&phone=%@&uid=%@"

//6.签到http://zsylou.wxwkf.com/index.php/home/checkin/index?x=40.453&y=111.890&location=马家堡西路10号院&uid=159
#define Qiaodao_URl @"http://zsylou.wxwkf.com/index.php/home/checkin/index?x=%f&y=%f&location=%@&uid=%@"
// 签到查询http://zsylou.wxwkf.com/index.php/home/checkin/query?uid=159
#define QiaodaoSearch_URL @"http://zsylou.wxwkf.com/index.php/home/checkin/query?uid=%@"

// 7.发布公告：http://zsylou.wxwkf.com/index.php/home/bbs/publish?title=测试标题&content=测试内容&type=1&top=1&uid=159
#define FabuGonggao @"http://zsylou.wxwkf.com/index.php/home/bbs/publish?title=%@&content=%@&type=1&top=%d&uid=%@"

// 8.查询公告
#define QueryGongao @"http://zsylou.wxwkf.com/index.php/home/bbs/query?uid=%@"

// 9.申请请假
/** http://zsylou.wxwkf.com/index.php/home/leave/ask?start=2016-04-19 0:0:0&finish=2016-04-22 0:0:0&days=3天&reason=病假去医院&type=病假  &approver=130&uid=159*/
#define Qingjia @"http://zsylou.wxwkf.com/index.php/home/leave/ask?start=%@&finish=%@&days=%@&reason=%@&type=%@&approver=%@&uid=%@"

// 10.外出申请
#define Waichu_URL @"http://zsylou.wxwkf.com/index.php/home/outgoing/appro?start=%@&finish=%@&longtime=%@&reason=%@&type=%@&approver=%@&uid=%@"

// 11.物品领用
/**http://zsylou.wxwkf.com/index.php/home/consuming/sply?usages=用途&items=物品名称&nums=数量&details=详情&approver=审核人&uid=2
 参数: usages 用途  items 物品名称 nums  数量   details  详情   approver  审核人
 除nums外 其余为必填项 */
#define Wupinlingyong_Url @"http://zsylou.wxwkf.com/index.php/home/consuming/sply?usages=%@&items=%@&nums=%@&details=%@&approver=%@&uid=%@"

// 12.通用审批 标题 title  内容 content  审批人 approver  192.168.0.199/index.php/home/sply/appro?title=通用测试&content=测试内容&approver=1&uid=2
#define TongyongShenpi @"http://zsylou.wxwkf.com/index.php/home/sply/appro?title=%@&content=%@&approver=%@&uid=%@"

// 13.审批的三个内页
//“我发起的”查询：
#define ShenpiStart_URL @"http://zsylou.wxwkf.com/index.php/home/approve/myappro?uid=%@"
//“待我审批”查询：
#define ShenpiWait_URL @"http://zsylou.wxwkf.com/index.php/home/approve/unappro?uid=%@"
//“我已审批”查询：
#define ShenpiAlready_URL @"http://zsylou.wxwkf.com/index.php/home/approve/approed?uid=%@"
//单个审批详情查询：
#define ShenpiWaitDeatil_URL @"http://zsylou.wxwkf.com/index.php/home/approve/query?id=%@&kind=%d&uid=%@"
//审批意见（同意还是拒绝）
#define shenpiSuggest @"http://zsylou.wxwkf.com/index.php/home/approve/approve?id=%@&kind=%d&opinion=%@&details=%@&uid=%@"

// 13.联系人头像、昵称、手机号、生日修改接口：
/**示例地址：http://zsylou.wxwkf.com/index.php/home/contacts/update?mobile=130119801196&head=&nickname=&birth=&uid=159
 参数：头像地址 head   昵称：nickname     手机号： mobile    生日：birth
 只要提交一个参数值*/
#define ConnectPerson_Url @"http://zsylou.wxwkf.com/index.php/home/contacts/update?mobile=%@&head=%@&nickname=%@&birth=%@&uid=%@"

// 14.今日财务 http://zsylou.wxwkf.com/index.php/home/todayfinance/query?date=2016-04-25&uid=159
#define Financial_Url @"http://zsylou.wxwkf.com/index.php/home/todayfinance/query?date=%@&uid=%@"

// 16.查询套系名称及价格
#define SearchTaoxi_URL @"http://zsylou.wxwkf.com/index.php/home/set/query_set?uid=%@"
// 16.业绩榜URL
#define YejiURL @"http://zsylou.wxwkf.com/index.php/home/record/query?date=%@&uid=%@"
// 17.预约接口
#define Yuyue_URL @"http://zsylou.wxwkf.com/index.php/home/order/order_id/?tradeid=%@&type=%d&date=%@&time=%@&uid=%@"

// 18.摄控本 http://zsylou.wxwkf.com/index.php/home/skb/query?date=2016-04-25&type=3&uid=159
/** 参数：日期 date  查询类目 type  （均可为空，为空时默认查询当日，拍照的信息） 查询类目 type 可选值  0拍照  ， 1选片   2看样   3取件 */
#define Shekongben_Url @"http://zsylou.wxwkf.com/index.php/home/skb/query?date=%@&type=%d&uid=%@"

// 19.摄控本日历
/**
 示例地址:http://zsylou.wxwkf.com/index.php/home/skb/query_section?date=2016-01-01&date2=2016-01-30&type=0&uid=159
 参数: date 统计起始日期  date2 统计结束日期  type 查询类目 (type 可选值  0拍照  ， 1选片   2看样   3取件)
 参数 "均可为空" ,为空时默认查询今日到之后30天的统计数据
 返回值为多维数组, 字段 type  类目   num 预约量  date 日期
 */
#define ShekongRili_Url @"http://zsylou.wxwkf.com/index.php/home/skb/query_section?uid=%@&date=%@&date2=%@&type=%d"

// 20.我的工作
/**
 http://zsylou.wxwkf.com/index.php/home/mywork/mywork?date=2016-01-01&uid=159
 参数:date 日期
 返回值   多维数组  分为:我的拍摄,我的选片,我的修片,我的精修,我的设计,我的看设计,我的取件任务
 下面各任务有不同返回值,大体有: 顾客名,妈妈电话,爸爸电话,套系,套系价格,门市,日期(或限期日期),服务人员
 */
#define MyWork_Url @"http://zsylou.wxwkf.com/index.php/home/mywork/mywork?date=%@&uid=%@"

// 21.今日订单
#define TodayOrder_Url @"http://zsylou.wxwkf.com/index.php/home/todaytrade/query?date=%@&uid=%@"
// 22.获取套系下的产品
#define TaoxiProduct_Url @"http://zsylou.wxwkf.com/index.php/home/SetProducts/query_set_products?name=%@&uid=%@"
// 23.获取所有产品
#define AllTaoxiProduct_Url @"http://zsylou.wxwkf.com/index.php/home/products/query?type=name=&uid=%@"
// 23. 查询景点
#define SearchSpot_Url @"http://zsylou.wxwkf.com/index.php/home/spot/query?uid=%@"
// 24.开单接口
#define OpenOrder_Url @"http://zsylou.wxwkf.com/index.php/home/newtrade/newtrade?uid=%@&price=%@&set=%@&guest=%@&msg=%@&mobile=%@&productlist=%@&spot=%@"

// 24.小红色求的显示(获取未读取数据(极光推送))(返回三组action和type   第一组是公告 ，第二组是待我审批 ，第三组是我发起的申请 )
#define IsReady_Url @"http://zsylou.wxwkf.com/index.php/home/IosIsRead/query_all_unread?uid=%@"

/** 25.修改接口.已读之后就把数据返回给后台,告诉此消息已读(参数 action  type  （ action:  1 公告  2 审批 type: 审批项目:  1 待我审批 , 2 我发起的 ）
 如果没有要修改为已读的消息 ，action 和type为空即可)*/
#define AlreadyReady_Url @"http://zsylou.wxwkf.com/index.php/home/IosIsRead/isreaded?uid=%@&action=%@&type=%@"

// 26.影楼之家
#define YLHome_Url @"http://zsylou.wxwkf.com/index.php/home/contacts/query?uid=%@"
// 我的影楼H5界面
#define MyStido_Url @"http://zsylou.wxwkf.com/index.php/home/MyYLou/query?uid=%@"
// 联系区域经理
#define ContactManager_Url @"http://zsylou.wxwkf.com/index.php/home/MarketManager/query?uid=%@"
// 27.版本更新
#define VersionUpdate_Url @"http://zsylou.wxwkf.com/index.php/home/version/query?os=2"

// 28.引导页
#define LeadPage_Url @"http://zsylou.wxwkf.com/index.php/home/CoverImg/query?uid=%@"

// 29.查询店铺所有员工的签到统计（次数）信息接口 (date 日期（可选)）http://zsylou.wxwkf.com/index.php/home/checkin/query_all_times?date=&uid=159
#define AllQianDao_URL @"http://zsylou.wxwkf.com/index.php/home/checkin/query_all_times?date=%@&uid=%@"

// 30.查询某一个员工的签到详细信息http://zsylou.wxwkf.com/index.php/home/checkin/query_the_one?id=144&date=2016-06-03&uid=159
#define AllQianDaoDetail_URL @"http://zsylou.wxwkf.com/index.php/home/checkin/query_the_one?id=%@&date=%@&uid=%@"

// 31.新增考勤组
#define CreateKaoqunGroup_Url @"http://zsylou.wxwkf.com/index.php/home/attence/new_attence_group?uid=%@&name=%@&type=%@&admins=%@&routers=%@&locations=%@&privilege_meter=%@&rules=%@&users=%@"

// 32.查询所有考勤组（返回具有管理权限的考勤组）
#define SearchKaoqunGroup_Url @"http://zsylou.wxwkf.com/index.php/home/attence/list_attence_group?uid=%@"

// 33.删除考勤组
#define DeleteKaoqinzu_Url @"http://zsylou.wxwkf.com/index.php/home/attence/del_attence_group?uid=%@&gid=%@"
// 34.查询所有考勤班次
#define AllBanci_Url @"http://zsylou.wxwkf.com/index.php/home/attence/list_attence_class?uid=%@"
// 35.新增班次
#define AddNewBanci_Url @"http://zsylou.wxwkf.com/index.php/home/attence/new_attence_class?uid=%@&start=%@&end=%@"
// 36.删除某个全局班次
#define DeleteOneBanci_Url @"http://zsylou.wxwkf.com/index.php/home/attence/del_attence_class?uid=%@&aid=%@"

// 37.查询员工当日的考勤规则接口(服务器给返回来的数据)
#define QiandaoDakaAll_Url  @"http://zsylou.wxwkf.com/index.php/home/attence/get_user_rule?uid=%@"

// 38.打卡成功传给服务器数据的接口
/**
 http://zsylou.wxwkf.com/index.php/home/attence/checkin?uid=159&type=1&id=&time=2016-06-309:10:00&location=[{%22address%22:%22%E9%A9%AC%E5%AE%B6%E5%A0%A1%E8%A5%BF%E8%B7%AF%E5%98%89%E5%9B%AD%E5%A4%A7%E7%A4%BE%E5%8C%BA%E6%97%B6%E4%BB%A3%E9%A3%8E%E5%B8%86%E5%A4%A7%E5%8E%A6%22,%22latitude%22:%2239.852299338103045%22,%22longitude%22:%22116.37695201886044%22}]&status=2&mark=10
 */
#define QiandaoDakaChenggong_Url @"http://zsylou.wxwkf.com/index.php/home/attence/checkin?uid=%@&type=%@&id=%@&time=%@&location=%@&status=%@&outside=%@&remark=%@"

// 39.统计中我的考勤
#define Count_MyKaoqin_Url @"http://zsylou.wxwkf.com/index.php/home/attence/user_count_checkin?uid=%@&month=%@"


// 40、团队考勤
#define TeamKaoqin_Url @"http://zsylou.wxwkf.com/index.php/home/attence/group_count_checkin?uid=%@&date=%@"

// 40.统计中团队考勤
#define Count_TeamKaoqin_Url @"http://zsylou.wxwkf.com/index.php/home/attence/group_count_checkin?uid=%@&date=%@"
// 41.查询订单收款的二维码
#define ErweimaImage_Url @"http://zsylou.wxwkf.com/index.php/home/PayCode/query?uid=%@&type=%@"
// 42、订单支付完成后的操作
#define FinishedPayOrder_Url @"http://zsylou.wxwkf.com/index.php/home/PayTrade/pay?uid=%@&type=%d&money=%@&trade_id=%@"
// 43、查询考勤组高级设置
#define SuperSet_Url @"http://zsylou.wxwkf.com/index.php/home/attence/query_whole?uid=%@"
// 44、考勤高级设置
#define GaojiSetting_Url @"http://zsylou.wxwkf.com/index.php/home/attence/update_whole?uid=%@&privilege_time=%@&latetime=%@&absent=%@&ontip=%@&offtip=%@&earlytime=%@&outtip=%d&sply=%d"
// 45、查询某成员是否已在某成员组
#define IsInSomeGroup_Url @"http://zsylou.wxwkf.com/index.php/home/attence/check_is_in_group?uid=%@"


#endif /* PCH_HTTP_URL_h */
