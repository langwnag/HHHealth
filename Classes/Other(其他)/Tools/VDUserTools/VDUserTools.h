//
//  VDUserTools.h
//  客邦
//
//  Created by SZR on 16/5/24.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"
#import "DDMenuController.h"
extern NSString * const ATLAESTONCELOGIN; //至少一次登录
extern NSString * const RCDTOKEN;// 融云token
extern NSString * const RCDCLIENTID;//融云ID

extern NSString * const CLIENTTOKEN;//合合token
extern NSString * const CLIENTHEADPORTRATION;//用户头像
extern NSString * const CLIENTNAME;//用户昵称
extern NSString * const CLIENTID;//用户ID
extern NSString * const SIGNCODE;//签约code值
extern NSString * const WAITCODE;//等待签约code值

typedef NS_ENUM(NSInteger,HHDoctorSignState){
    HHDoctorSignStateNoCommitSign = -1,
    HHDoctorSignStateCommitSignNoAgree,
    HHDoctorSignStateAlreadySign
};




@interface VDUserTools : NSObject
@property (nonatomic, strong) UINavigationController *nav;

@property(nonatomic,strong)UIViewController * loginFromePage;
@property(nonatomic,strong)LoginModel * loginModel;
+(instancetype)defaultManger;

+(void)VDSaveLoginMessege:(NSDictionary *)userDic;
+(void)HH_UpdateUserInfomation:(LoginModel *)model;
+(LoginModel *)VDGetLoginModel;


/**
 至少token登录一次
 */
+(void)VD_ATLAESTONCELOGIN:(BOOL)ret;

/**
 获取一次登录
 */
+(BOOL)VD_GET_ATLAESTONCELOGIN;

/**
 *  存token
 */
+(void)VD_SaveToken:(NSString *)token;
/**
 *  获取token
 */
+(NSString *)VD_GetToken;
/**
 *  获取融云token
 */
+(NSString *)VD_GetRCToken;


/**
 登录过期处理

 @param VC 登录跳转钱页面
 */
+(void)TokenExpire:(UIViewController *)VC;

/**
 登陆成功处理

 @param VC 跳转TabBar控制器（首页）
 */
+(void)skipToMainVC:(UIViewController *)VC;


/**
 缓存处理
 */
+(void)HH_ChangeDBPath;
+(void)VD_SaveUserPrivateDoctorArr:(NSArray* )arr;
+(NSArray* )VD_UserPrivateDoctorArr;

+(void)HH_SavePriviteDoctor:(NSDictionary *)userDic;
+(void)HH_InsertPrivateDoctor:(NSArray *)privateDoctorArr;
+(NSInteger)HH_SelectPrivateDoctorState:(int)doctorId;
+(void)HH_UpdateDoctorSignState:(int)doctorID signState:(NSInteger)signState;
+(NSInteger)HH_CountOfSignedDoctor;

+(void)HH_InsertContactDoctor:(NSArray *)contactDoctorArr finish:(void(^)(void))finish;
+(NSArray *)HH_SelectContactDoctor:(id)doctorTypeID;
@end
