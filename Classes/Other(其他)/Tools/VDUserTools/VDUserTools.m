//
//  VDUserTools.m
//  客邦
//
//  Created by SZR on 16/5/24.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "VDUserTools.h"
#import "HHUserAccount.h"
#import "HHUserInformation.h"
#import "HHUserToken.h"
#import "HHAddUserInformation.h"
#import "HHLoginVC.h"
#import "PrivateDoctorModel.h"
#import "DoctListModel.h"

NSString * const ATLAESTONCELOGIN = @"ATLAESTONCELOGIN"; //至少一次登录
NSString * const RCDTOKEN = @"RCDTOKEN";// 融云token
NSString * const RCDCLIENTID = @"RCDCLIENTID";// 融云ID

NSString * const CLIENTTOKEN = @"CLIENTTOKEN";// 用户token
NSString * const CLIENTHEADPORTRATION = @"pictureUrl";//用户头像
NSString * const CLIENTNAME = @"name";//用户昵称
NSString * const CLIENTID = @"userId";//用户ID
NSString * const SIGNCODE = @"USER_PRIVATE_DOCTOR_SIGN";//已签约标记
NSString * const WAITCODE = @"USER_PRIVATE_DOCTOR_WAIT";//等待签约标记
NSString * const userPrivateDoctor = @"userPrivateDoctor";
@implementation VDUserTools

+ (instancetype)defaultManger{
    static VDUserTools * Manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Manager = [[VDUserTools alloc]init];
    });
    return Manager;
}

+ (void)VDSaveLoginMessege:(NSDictionary *)userDic{
    
    LoginModel * loginModel = [[LoginModel alloc]init];
    [loginModel setValuesForKeysWithDictionary:userDic];
    loginModel.pictureUrl = userDic[@"userIcon"][@"pictureUrl"];
    // 用户账号
    HHUserAccount* userAccount = [[HHUserAccount alloc] init];
    [userAccount setValuesForKeysWithDictionary:userDic[@"userAccount"]];
    // 用户信息
    if (userDic[@"userInformation"]) {
        HHUserInformation* userInfo = [[HHUserInformation alloc] init];
        [userInfo setValuesForKeysWithDictionary:userDic[@"userInformation"]];
        long long dataBirth = [userInfo.dateBirth longLongValue]/1000;
        userInfo.dateBirth = [[NSDate dateWithTimeIntervalSince1970:dataBirth] formatYMD];
        loginModel.userInformation = userInfo;
    }
    // 用户token
    HHUserToken* userToken = [[HHUserToken alloc] init];
    [userToken setValuesForKeysWithDictionary:userDic[@"userToken"]];
    // 赋值
    loginModel.userAccount = userAccount;
    loginModel.userToken = userToken;
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:loginModel];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:data forKey:@"LoginModel"];
    // 用户信息
    if (userDic[@"userToken"][@"token"]) {
        [userDefault setObject:userDic[@"userToken"][@"token"] forKey:CLIENTTOKEN];
    }
    [userDefault setObject:userDic[@"userIcon"][@"pictureUrl"] forKey:CLIENTHEADPORTRATION];
    if ([userDic[@"userInformation"][@"name"] isEqualToString:@""]) {
        if ([userDic[@"nickname"] isEqualToString:@""]) {
            [userDefault setObject:userDic[@"phone"] forKey:CLIENTNAME];
        }else{
            [userDefault setObject:userDic[@"nickname"] forKey:CLIENTNAME];
        }
        
    }else{
        [userDefault setObject:userDic[@"userInformation"][@"name"] forKey:CLIENTNAME];
    }
    [userDefault setObject:userDic[@"userId"] forKey:CLIENTID];

    [userDefault synchronize];
    
    [self HH_ChangeDBPath];
    [self HH_SavePriviteDoctor:userDic];
    
}

+(void)HH_ChangeDBPath{
    [[JKDBHelper shareInstance]changeDBWithDirectoryName:[NSString stringWithFormat:@"HHPrivateDoctorInfo%@",[DEFAULTS objectForKey:CLIENTID]]];
}


+(void)HH_SavePriviteDoctor:(NSDictionary *)userDic{
    
    NSArray * privateDoctorArr = [PrivateDoctorModel mj_objectArrayWithKeyValuesArray:userDic[@"userPrivateDoctor"]];
    [self HH_InsertPrivateDoctor:privateDoctorArr];
    
}

+(void)HH_UpdateUserInfomation:(LoginModel *)model{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:model];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:data forKey:@"LoginModel"];
    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateUserInfoNofiName object:self];
    [userDefault synchronize];
}

+(LoginModel *)VDGetLoginModel{
    return (LoginModel *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginModel"]];
}



+(void)VD_ATLAESTONCELOGIN:(BOOL)ret{
    [[NSUserDefaults standardUserDefaults] setObject:@(ret) forKey:ATLAESTONCELOGIN];
}
+(BOOL)VD_GET_ATLAESTONCELOGIN{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:ATLAESTONCELOGIN] boolValue];
}


/**
 *  存token
 */
+(void)VD_SaveToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:CLIENTTOKEN];
}
/**
 *  获取token
 */
+(NSString *)VD_GetToken{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:CLIENTTOKEN]) {
        return [[NSUserDefaults standardUserDefaults]objectForKey:CLIENTTOKEN];
    }else{
        return @"";
    }
}
+ (NSString *)VD_GetRCToken{

    if ([[NSUserDefaults standardUserDefaults] objectForKey:RCDTOKEN]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:RCDTOKEN];
    }else{
    return @"";
    }

}
+ (void)VD_SaveUserPrivateDoctorArr:(NSArray *)arr{
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:userPrivateDoctor];
}
+ (NSArray *)VD_UserPrivateDoctorArr{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:userPrivateDoctor]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:userPrivateDoctor];
    }else{
        return @[];
    }
}


+(void)TokenExpire:(UIViewController *)VC{
    [DEFAULTS setValue:@"" forKey:CLIENTTOKEN];
    [[RCIM sharedRCIM]logout];
    HHLoginVC * loginVC = [[HHLoginVC alloc]init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    // 通过window根式图进行切换
    VC.view.window.rootViewController = nav;
}


+ (void)skipToMainVC:(UIViewController *)VC{
       VC.view.window.rootViewController = [DDMenuController shareDDMenuVC];
}


#pragma mark 签约医生数据库操作
+(void)HH_InsertPrivateDoctor:(NSArray *)privateDoctorArr{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (PrivateDoctorModel * model in privateDoctorArr) {
            
            [model saveOrUpdateByColumnName:@"doctorId" AndColumnValue:[NSString stringWithFormat:@"%d",model.doctorId]];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kUpdatePrivateHealthVCCellSignedDoctor" object:self];
//        SZRLog(@"登录成功后返回数据 arr = %@",[PrivateDoctorModel findAll]);
    });
    
}

+(NSInteger)HH_SelectPrivateDoctorState:(int)doctorId{
    PrivateDoctorModel * model = [PrivateDoctorModel findFirstByCriteria:[NSString stringWithFormat:@" WHERE doctorId = %d ",doctorId]];
    if (model.state) {
        return [model.state isEqualToString:@"0"] ? HHDoctorSignStateCommitSignNoAgree : HHDoctorSignStateAlreadySign;
    }else{
        return HHDoctorSignStateNoCommitSign;
    }
    
}

+(void)HH_UpdateDoctorSignState:(int)doctorID signState:(NSInteger)signState{
    PrivateDoctorModel * model = [PrivateDoctorModel findFirstByCriteria:[NSString stringWithFormat:@" WHERE doctorId = %d ",doctorID]];
    model.state = [NSString stringWithFormat:@"signState"];
    DoctListModel * doctorListModel = nil;
    if (signState == 1) {
        //更新签约医生数据
        doctorListModel = [DoctListModel findFirstByCriteria:[NSString stringWithFormat:@" WHERE doctorId = %d ",doctorID]];
        doctorListModel.signState = 1;
        
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [model update];
        if (doctorListModel) {
            [doctorListModel update];
        }
    });
}

+(NSInteger)HH_CountOfSignedDoctor{
    NSArray * signedDoctorArr = [PrivateDoctorModel findByCriteria:@"where state = 1"];
    return signedDoctorArr.count;
}



#pragma mark 医生列表数据库
+(void)HH_InsertContactDoctor:(NSArray *)contactDoctorArr finish:(void(^)(void))finish{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (DoctListModel * model in contactDoctorArr) {
        //判断此医生是否签约
        NSInteger state = model.signState || [self HH_SelectPrivateDoctorState:[model.doctorId intValue]] == HHDoctorSignStateAlreadySign;
            SZRLog(@"state = %zd model.signState = %zd [self HH_SelectPrivateDoctorState:[model.doctorId intValue]] = %zd",state,model.signState,[self HH_SelectPrivateDoctorState:[model.doctorId intValue]]);

        [model saveOrUpdateByColumnName:@"doctorId" AndColumnValue:model.doctorId];
        }
        if (finish) {
            finish();
        }
        
        SZRLog(@"所有此类型医生 = %@",[DoctListModel findAll]);
    });
    
    
}

+(NSArray *)HH_SelectContactDoctor:(id)doctorTypeID{
    NSArray * allSignedDoctorArr = [DoctListModel findByCriteria:[NSString stringWithFormat:@"where doctorTypeId = %@ and signState = 1",doctorTypeID]];
    NSArray * allNoSignedDoctorArr = [DoctListModel findByCriteria:[NSString stringWithFormat:@"where doctorTypeId = %@ and signState = 0",doctorTypeID]];
    
    NSMutableArray * marr = [[NSMutableArray alloc]initWithArray:allSignedDoctorArr];
    [marr addObjectsFromArray:allNoSignedDoctorArr];
   
    SZRLog(@"marr = %@",marr);
    return marr;
}




@end
