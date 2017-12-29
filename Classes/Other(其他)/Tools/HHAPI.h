//
//  HHAPI.h
//  YiJiaYi
//
//  Created by SZR on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#ifndef HHAPI_h
#define HHAPI_h
//AppStore
#define STOREAPPID @"1187795698"
//融云
#define RONGCLOUD_IM_APPKEY @"25wehl3u2jw5w" // 开发环境
//友盟分享
#define UMSHARE_APPKEY @"589a7ab34ad1565b0d00011d"

//掌厨第三方接口
//appid
#define COOKING_APPID @"225858ca5671aca4658eef91fe445a87"
//appkey
#define COOKING_APPKEY @"f533b9849bcf7493"
#define COOKINGServiceURL @"http://api.izhangchu.com"


// 服务器外网IP地址   http://121.42.210.227:8080/hehe-api
//                  https://www.hehehome.cn:8443/hehe-api/
#define VDOutsideServiceURL @"https://www.hehehome.cn:8443/hehe-api/"
// 服务器内网IP地址  @"http://192.168.0.124:8080/hehe-api/"
#define VDInsideServiceURL @"http://192.168.0.124:8080/hehe-api/"

#define VDNewServiceURL VDOutsideServiceURL

#define kURL(URL) [NSString stringWithFormat:@"%@%@",VDNewServiceURL,URL]

/******   阿里云   ******/
#define OSSEndPoint @"http://oss-cn-shanghai.aliyuncs.com"
#define OSSSTSServer [NSString stringWithFormat:@"%@oss/sts/user/getlatest.html",VDNewServiceURL]
//#define OSSSTSServer @"http://121.42.210.227:8080/hehe-api/oss/sts/user/getlatest.html"

#define OSSImagePrefixURL @"http://hehe-resource.oss-cn-shanghai.aliyuncs.com/"

/************************* 登录 注册 **********************************/
// 短信发送接口
#define VDCode_Url [NSString stringWithFormat:@"%@send/sms/user/register.html",VDNewServiceURL]
// 判断验证码是否正确
#define VDCodeIsSucess_Url [NSString stringWithFormat:@"%@message/verification/code.app",VDNewServiceURL]
// 注册
#define VDRegister_Url [NSString stringWithFormat:@"%@consumer/user/register.html",VDNewServiceURL]
// 密码登录
#define VDLogin_Url [NSString stringWithFormat:@"%@consumer/user/login.html",VDNewServiceURL]
// 自动登录
#define VDAKeyLogin_Url [NSString stringWithFormat:@"%@consumer/user/token/login.html",VDNewServiceURL]

// 发送修改密码的验证码
#define VDRequirePwdCode_Url [NSString stringWithFormat:@"%@send/sms/user/updatePasswordCode.html",VDNewServiceURL]
// 用户通过验证码修改密码
#define VDVerificationModifyPwd_Url [NSString stringWithFormat:@"%@consumer/user/updateUserPassword.html",VDNewServiceURL]
// 用户通过原密码修改密码
#define VDModifyPwd_Url [NSString stringWithFormat:@"%@consumer/user/updateUserPasswordByOldPassword.html",VDNewServiceURL]

/************************* 完善资料 **********************************/
// 服务城市
#define VDServiceCity_Url [NSString stringWithFormat:@"%@serve/city/getCanServeCity.html",VDNewServiceURL]
// 病史
#define VDAddUserInfo_Url [NSString stringWithFormat:@"%@consumer/user/add/information.html",VDNewServiceURL]

/************************* 自我检测 **********************************/
//一级病史
#define VDDiseaseFirstLevel_URL [NSString stringWithFormat:@"%@consumer/userHistory/selectHistory.app",VDNewServiceURL]

/************************* 详细症状 **********************************/
//病史二级或多级
#define VDDiseaseSecondLevel_URL [NSString stringWithFormat:@"%@consumer/userHistory/selectBySuperclassId.app",VDNewServiceURL]

/************************* 首页医生类别 **********************************/
//获取医生类别
#define VDDoctorCategory_URL [NSString stringWithFormat:@"%@consumer/doctor/type/list.html",VDNewServiceURL]
//获取医生列表
#define VDDoctorList_URL [NSString stringWithFormat:@"%@consumer/doctor/list.html",VDNewServiceURL]



/************************* 会话界面 **********************************/
/*
 * 上门家访
 */

//根据机构id和等级id获取到服务类型
#define HH_ServiceType_URL [NSString stringWithFormat:@"%@service/home/selectServiceTypeByAgentIdAndLevelId.html",VDNewServiceURL]

//用户发起上门家访
#define HH_FamilyVisit_URL [NSString stringWithFormat:@"%@user/home/insertUserServiceHome.html",VDNewServiceURL]

//用户查询已提交的上门家访订单
#define HH_QueryFamilyVisit_URL [NSString stringWithFormat:@"%@user/home/selectUserServiceHomeList.html",VDNewServiceURL]

//查询支付方式
#define HH_QueryMethodPayment_URL [NSString stringWithFormat:@"%@sysPayment/selectPaymentList.html",VDNewServiceURL]

//家访订单支付
#define HH_FamilyVisitOrderPayment_Url [NSString stringWithFormat:@"%@user/home/addUserServiceHomePay.html",VDNewServiceURL]

//取消家访订单
#define HH_FamilyVisitOrderCancel_Url [NSString stringWithFormat:@"%@user/home/updateServiceHomeStateToUserRefuse.html",VDNewServiceURL]



/**************  融云  ****************/
#define HHClientRCDefaultPortraitUri @"http://hehe-resource.oss-cn-shanghai.aliyuncs.com/hehe/doctor/Icon/doctor_default_icon.png"

//查询用户头像 昵称
#define HH_QueryRCInfo [NSString stringWithFormat:@"%@consumer/doctor/selectHeadAndNameByIds.html",VDNewServiceURL]


// 用户端获取融云token
#define VDCLIENTRCDTokenURL [NSString stringWithFormat:@"%@rongcloud/user/token.html",VDNewServiceURL]

/************************* 提交签约信息 **********************************/
//提交签约
#define VDSIGNUP_URL [NSString stringWithFormat:@"%@private/doctor/update.html",VDNewServiceURL]

//用户根据医师类别查询已签约医师
#define VDHASSIGNEDDoctors_URL [NSString stringWithFormat:@"%@private/doctor/selectUserPrivateDoctorByType.html",VDNewServiceURL]


/************************* 寻诊 **********************************/
//医生类别列表
#define VDDoctorCategoryList_URL [NSString stringWithFormat:@"%@consumer/doctor/type/droplist.html",VDNewServiceURL]
//选择医生列表
#define VDDoctorSelectList_URL [NSString stringWithFormat:@"%@consumer/user/inquiring.html",VDNewServiceURL]

/************************* 体检 **********************************/
//查询体检服务城市
#define VDMedicalCity_URL [NSString stringWithFormat:@"%@user/medical/selectServiceCity.html",VDNewServiceURL]
//根据服务城市id获取该地区的体检中心
#define VDObtainMedicalCenter_URL [NSString stringWithFormat:@"%@user/medical/selectMedicalUnit.html",VDNewServiceURL]
//根据体检中心id获取到该中心可用的时间
#define VDPhysicalExamTime_URL [NSString stringWithFormat:@"%@user/medical/selectMedicalAppointment.html",VDNewServiceURL]
//添加用户体检申请
#define VDMedicalApplication_URL [NSString stringWithFormat:@"%@user/medical/insertUserMedical.html",VDNewServiceURL]


/************************* vip中心 **********************************/

#define HH_UpdatedIcon [NSString stringWithFormat:@"%@serve/callback/user/updateIcon.html",VDNewServiceURL]
#define HH_UpdateNickName [NSString stringWithFormat:@"%@consumer/user/update/nickname.html",VDNewServiceURL]
//修改用户信息
#define HH_UpdateUserInfo [NSString stringWithFormat:@"%@consumer/userInformation/update/userInformation.html",VDNewServiceURL]


/**************  版本更新  ****************/
//版本更新
#define HHVerson_UpdataURL [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",STOREAPPID]

/**************  掌厨第三方接口  ****************/






/**************  后台定义字段  ****************/
#define RESULT @"result"
#define SUCCESS @"issucces"
#define MESSAGE @"message"
#define CODE @"code"
#define DATA @"data"
#define VD_TokenExpireStr @"您的登录已经过期,请重新登录!"
#define CODE_ENUM [HHConnectCodeStrArr indexOfObject:responseObject[CODE]]
#define kBGDataStr [RSAAndDESEncrypt DESDecrypt:responseObject[DATA]]

/**************  通知名称  ****************/
#define kUpdateUserInfoNofiName @"kUpdateUserInfoNofiName"

#endif /* HHAPI_h */
