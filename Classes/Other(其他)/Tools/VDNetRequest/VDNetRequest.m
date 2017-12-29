//
//  VDNetRequest.m
//  客邦
//
//  Created by SZR on 16/4/27.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "VDNetRequest.h"
#import "Reachability.h"
#import "YYCache.h"
#import "MD5UTils.h"

NSString * const VDHTTPPARAMETERS = @"VDHTTPPARAMETERS";
NSString * const VDHTTPCONTENTTYPE = @"VDHTTPCONTENTTYPE";
NSString * const VDHTTPIMAGEARR = @"VDHTTPIMAGEARR";       //HTTP 上传图片
NSString * const VDBGIMAGENAMEARR = @"VDBGIMAGENAMEARR";     //后台接收的字段/参数
NSString * const VDFILEPATH = @"VDFILEPATH";        //文件路径
NSString * const VDBGFILENAME = @"VDBGFILENAME";    //后台接受文件字段/参数
NSString * const VDCACHEPATH = @"VDCACHEPATH";       //缓存路径


@implementation VDNetRequest
static NSString * const HTTP_DATA_CACHE = @"SINOKRU_HTTP_CACHE";
static AFHTTPSessionManager *_manager;
static NSMutableArray *_allSessionTask;
static YYCache *_dataCache;


/**
 *  创建sessionManager单例对象
 *
 *  @param attribute 属性列表
 *
 *  @return 返回sessionManager单例对象
 */
+(AFHTTPSessionManager *)createHttpManager:(NSDictionary *)attribute{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.0f;
    /*************为了HTTPS新加代码****************/
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager setSecurityPolicy:[VDNetRequest customSecurityPolicy]];

    if (attribute[VDHTTPCONTENTTYPE]) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:attribute[VDHTTPCONTENTTYPE], nil];
    }
    // 申请cache
    _dataCache = [YYCache cacheWithName:HTTP_DATA_CACHE];
    return manager;
   
}
+ (AFSecurityPolicy* )customSecurityPolicy{
    // 获取证书
    NSString* cerPath = [[NSBundle mainBundle] pathForResource:@"RapidSSLSHA256CA" ofType:@"cer"];
    NSData* certData = [NSData dataWithContentsOfFile:cerPath];
    // 验证公钥和证书的其他消息
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // 允许自建证书（是否允许,NO— 不允许无效的证书）
    securityPolicy.allowInvalidCertificates = YES;
    
    // 效验域名信息
    securityPolicy.validatesDomainName      = YES;
    
    // 设置证书（你把这个代码注释掉，用http先跑一下）
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:certData, nil];
    
    return securityPolicy;
    
}

//普通get请求
+(NSURLSessionDataTask *)VD_GetWithURL:(NSString *)url arrtribute:(NSDictionary *)arrtribute finish:(VDHttpFinishBlock)finish{
    
    return [[self createHttpManager:arrtribute] GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finish(task,responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finish(task,nil,error);
    }];
  
}

+(void)VD_GetWithURL:(NSString * )url arrtribute:(NSDictionary *)arrtribute finish:(VDHttpFinishBlock)finish noNetwork:(NONetworkBlock)noNetwork{
    if ([self haveNet]) {
        [self VD_GetWithURL:url arrtribute:arrtribute finish:finish];
    }else{
        noNetwork();
    }
}

//普通post请求
+(NSURLSessionDataTask *)VD_PostWithURL:(NSString *)url arrtribute:(NSDictionary *)arrtribute finish:(VDHttpFinishBlock)finish{
   return [[self createHttpManager:arrtribute] POST:url parameters:arrtribute[VDHTTPPARAMETERS] progress:nil success:^(NSURLSessionDataTask  * _Nonnull task, id  _Nullable responseObject) {
        finish(task,responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finish(task,nil,error);
    }];
}
+(void)VD_PostWithURL:(NSString *)url arrtribute:(NSDictionary *)arrtribute finish:(VDHttpFinishBlock)finish noNetwork:(NONetworkBlock)noNetwork{
    if ([self haveNet]) {
        [self VD_PostWithURL:url arrtribute:arrtribute finish:finish];
    }else{
        noNetwork();
    }
}

//带缓存post请求
+(NSURLSessionDataTask *)VD_PostWithURL:(NSString *)url arrtribute:(NSDictionary *)arrtribute cache:(BOOL)cache finish:(VDHttpFinishBlock)finish{
    if (cache) {
        id responseObject = [_dataCache objectForKey:url];

        finish(nil,responseObject,nil);
    }
    return [[self createHttpManager:arrtribute] POST:url parameters:arrtribute[VDHTTPPARAMETERS] progress:nil success:^(NSURLSessionDataTask  * _Nonnull task, id  _Nullable responseObject) {
      
        if (cache) {
            NSData *  cacheData = (NSData *)[_dataCache objectForKey:url];
            NSString * cacheMd5 = [MD5UTils getMD5WithData:cacheData];
            NSString * responseMd5 = [MD5UTils getMD5WithData:responseObject];
            
            if (![cacheMd5 isEqualToString:responseMd5]) {
                finish(task,responseObject,nil);
            }
            [_dataCache setObject:responseObject forKey:url];
        }else{
            finish(task,responseObject,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finish(task,nil,error);
    }];
}


+(BOOL)haveNet{
    //wifi
    Reachability * wifi = [Reachability reachabilityForLocalWiFi];
    //流量
    Reachability * conn = [Reachability reachabilityForInternetConnection];
    
    if ([wifi currentReachabilityStatus] != NotReachable || [conn currentReachabilityStatus] != NotReachable) {
        return YES;
    }else{
        return NO;
    }
}
+(void)VD_PostWithCache:(NSString *)url arrtribute:(NSDictionary *)arrtribute finish:(VDHttpFinishBlock)finish isCache:(BOOL)isCache isFirstRequest:(BOOL)isFirstRequest{
    
    //缓存路径
    NSString * path = [NSHomeDirectory() stringByAppendingFormat:@"/Library/%@",arrtribute[VDCACHEPATH]];
    NSLog(@"缓存路径 💙💙 path = %@",path);
    
    if (isCache && !isFirstRequest) {
        //是缓存 但是不是第一次请求
        if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
            //缓存路径下有数据
            NSData * data = [NSData dataWithContentsOfFile:path];
            NSLog(@"从缓存拿数据");
            finish(nil,data,nil);
        }
        
    }else{
        [[self createHttpManager:arrtribute] POST:url parameters:arrtribute[VDHTTPPARAMETERS] progress:nil success:^(NSURLSessionDataTask  * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[RESULT] boolValue] && isCache) {
                NSMutableArray * marr = [NSMutableArray arrayWithArray:[path componentsSeparatedByString:@"/"]];
                [marr removeLastObject];
                
                [[NSFileManager defaultManager] createDirectoryAtPath:[marr componentsJoinedByString:@"/"] withIntermediateDirectories:YES attributes:nil error:nil];
                //成功
                [responseObject writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
            finish(task,responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            finish(task,nil,error);
        }];
    }
    
    
}


+(void)VD_OSSImageView:(UIImageView *)imageView fullURLStr:(NSString *)URLStr placeHolderrImage:(NSString *)placeHolderImage{
    [imageView sd_setImageWithURL:[NSURL URLWithString:URLStr] placeholderImage:[UIImage imageNamed:placeHolderImage]];
}


/*
 *********************************************************************************
 *                                                                                *
 * 缓存相关操作                                                                      *
 *                                                                                *
 *********************************************************************************
 
 */
#pragma mark 保存数据到磁盘
+ (void)saveCache:(id)httpData
              URL:(NSString *)URL
       parameters:(NSDictionary *)parameters {
    
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    [_dataCache setObject:httpData forKey:cacheKey withBlock:nil];
}
#pragma mark 从缓存中取出数据
+ (id)cacheForURL:(NSString *)URL
       parameters:(NSDictionary *)parameters {
    
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    return [_dataCache objectForKey:cacheKey];
}
#pragma mark 获取域名与地址组合的缓存KEY
+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    if(!parameters){return URL;};
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",URL,paraString];
    
    return cacheKey;
}
#pragma mark 清空所有缓存数据
+ (void)clearCaches {
    [_dataCache.diskCache removeAllObjects];
}
#pragma mark 获取缓存数据大小
+ (float)getCacheFileSize {
    return [_dataCache.diskCache totalCost];
}




+(void)VD_GetRongCloudToken:(void(^)(NSDictionary * dic))success BGError:(void(^)(id responseObject))BGError Error:(void(^)())Error{
    NSDictionary* dataDic = @{@"token":[VDUserTools VD_GetToken]};
    [VDNetRequest VD_PostWithURL:VDCLIENTRCDTokenURL arrtribute:@{VDHTTPPARAMETERS:dataDic} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject[RESULT] boolValue]) {
                NSDictionary* userDic = [SZRFunction dictionaryWithJsonString:[RSAAndDESEncrypt DESDecrypt:responseObject[DATA]]];
//                SZRLog(@"融云Token %@",[RSAAndDESEncrypt DESDecrypt:responseObject[DATA]]);
                if (success) {
                    success(userDic);
                }
                
            }else{
                if (BGError) {
                    BGError(responseObject);
                }
            }
        }else{
            if (Error) {
                Error();
            }
        }
        
    }];
}

+(void)VD_GetHHToken:(void(^)(NSDictionary * dic))success BGError:(void(^)(id responseObject))BGError Error:(void(^)())Error{
    NSDictionary* dataDic = @{@"token":[VDUserTools VD_GetToken]};
    NSString* str = [RSAAndDESEncrypt encrypt:[SZRFunction dictionaryToJson:dataDic]];
    [VDNetRequest VD_PostWithURL:VDAKeyLogin_Url arrtribute:@{VDHTTPPARAMETERS:@{@"data":str}} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject[RESULT] boolValue]) {
        
                NSDictionary* userDic = [SZRFunction dictionaryWithJsonString:[RSAAndDESEncrypt DESDecrypt:responseObject[DATA]]];
                if (success) {
                    success(userDic);
                }
            }else{
                if (BGError) {
                    BGError(responseObject);
                }
            }
        }else{
            if (Error) {
                Error();
            }
        }
    }];
}


+ (void)HH_GetUserInfo:(NSString *)userId
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure{
    NSDictionary * paramDic = [RSAAndDESEncrypt encryptParams:@{@"doctorId":[SZRFunction idWithRCID:userId]} token:NO];
    [VDNetRequest VD_PostWithURL:HH_QueryRCInfo arrtribute:@{VDHTTPPARAMETERS:paramDic} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        SZRLog(@"获取用户头像responseObject = %@,error = %@",responseObject,error);
        if (!error) {
            if (![responseObject[RESULT] boolValue]) {
                if (failure) {
                    failure(nil);
                }
            }else{
                SZRLog(@"HH_GetUserInfo");
                SZRLog(@"用户信息 = %@",kBGDataStr);
                success([RSAAndDESEncrypt DESDecryptResponseObject:responseObject]);
            }
            
        }else{
            if (failure) {
                failure(nil);
            }
        }
        
    } noNetwork:^{
        if (failure) {
            failure(nil);
        }
    }];
    
    
}



//修改用户信息
+(void)HH_UpdateNickNameRequest:(NSDictionary *)paramDic success:(void(^)(NSDictionary * dic))success viewController:(UIViewController *)viewController{
    [MBProgressHUD showMessage:@"正在修改..."];
    [VDNetRequest VD_PostWithURL:HH_UpdateNickName arrtribute:@{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:paramDic token:YES]} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            SZRLog(@"responseObject = %@",responseObject);
            if (![responseObject[RESULT] boolValue]) {
                VD_ShowBGBackError(YES);
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:viewController];
                }
            }else{
                kBGDataStr;
                success(nil);
                [MBProgressHUD showTextOnly:@"修改成功" hideBeforeShow:YES];
                
            }
        }else{
            SZRLog(@"回调地址error = %@",error);
            VD_SHowNetError(YES);
        }
        
    } noNetwork:^{
        VD_SHowNetError(YES);
    }];
}

//修改用户信息
+(void)HH_UpdateUserInfoRequest:(NSDictionary *)paramDic success:(void(^)(NSDictionary * dic))success viewController:(UIViewController *)viewController{
    [MBProgressHUD showMessage:@"正在修改..."];
    [VDNetRequest VD_PostWithURL:HH_UpdateUserInfo arrtribute:@{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:paramDic token:YES]} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            SZRLog(@"responseObject = %@",responseObject);
            if (![responseObject[RESULT] boolValue]) {
                VD_ShowBGBackError(YES);
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:viewController];
                }
            }else{
                kBGDataStr;
                success(nil);
                [MBProgressHUD showTextOnly:@"修改成功" hideBeforeShow:YES];
                
            }
        }else{
            SZRLog(@"回调地址error = %@",error);
            VD_SHowNetError(YES);
        }
        
    } noNetwork:^{
        VD_SHowNetError(YES);
    }];
}

//提交签约
+(void)HH_CommitSign:(NSString *)doctorID success:(void(^)(NSDictionary * dic))success viewController:(UIViewController *)viewController showHud:(BOOL)showHud{
    if (showHud) {
       [MBProgressHUD showMessage:@"正在提交..."];
    }
    
    NSDictionary* paramsDic = @{@"doctorId":doctorID};
    [VDNetRequest VD_PostWithURL:VDSIGNUP_URL arrtribute:@{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:paramsDic token:YES]} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        SZRLog(@"responseObject = %@ error = %@",responseObject,error);
        if (!error) {
            if (![responseObject[RESULT] boolValue]) {

                !showHud ? : VD_ShowBGBackError(YES) ;
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:viewController];
                }
            }else{
                if (success) {
                    success(responseObject);
                }
                !showHud ? : [MBProgressHUD showTextOnly:responseObject[MESSAGE] hideBeforeShow:YES];
            }
        }else{
            !showHud ? : VD_SHowNetError(YES);
        }
    } noNetwork:^{
        !showHud ? : VD_SHowNetError(YES);
    }];

}


/**
 上门家访接口
 */
//获取服务类型
+(void)HH_GetServiceType:(NSDictionary *)paramDic viewController:(UIViewController *)viewController success:(void(^)(NSArray *))success{
    [VDNetRequest VD_PostWithURL:HH_ServiceType_URL arrtribute:@{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:paramDic token:YES]} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if (![responseObject[RESULT] boolValue]) {
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:viewController];
                }
                VD_ShowBGBackError(NO);
            }else{
                SZRLog(@"服务类型 = %@",kBGDataStr);
                if (success) {
                    success([RSAAndDESEncrypt DESDecryptResponseObject:responseObject]);
                }
            }
        }else{
            SZRLog(@"error = ")
        }
    } noNetwork:^{
        
    }];
}
// 用户查询已提交上门家访订单
+(void)HH_SelectFamilyVisit:(NSDictionary *)paramDic success:(void (^)(NSArray *))success BGError:(void (^)(id))BGError endRefresh:(void (^)(void))endRefresh viewController:(UIViewController *)viewController{

    [VDNetRequest VD_PostWithURL:HH_QueryFamilyVisit_URL arrtribute:@{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:paramDic token:YES]} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if (![responseObject[RESULT] boolValue]) {
                if (BGError) {
                    BGError(responseObject);
                }
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:viewController];
                }
            }else{
                SZRLog(@"用户查询已提交上门家访订单 %@",kBGDataStr);
                success([RSAAndDESEncrypt DESDecryptResponseObject:responseObject]);
            }
        }else{
            SZRLog(@"error %@",error);
            if (endRefresh) {
                endRefresh();
            }
            VD_SHowNetError(YES);
        }
    } noNetwork:^{
        if (endRefresh) {
            endRefresh();
        }
        VD_SHowNetError(YES);
    }];

}



+(void)HH_RequestHandle:(NSDictionary *)paramDic
                    URL:(NSString *)URL
         viewController:(UIViewController *)viewController
                success:(void(^)(id responseObject))success
                failureEndRefresh:(void(^)(void))failureEndRefresh
                showHUD:(BOOL)showHud
                 hudStr:(NSString *)hudStr
{

    if (showHud) {
        [MBProgressHUD showMessage:hudStr];
    }
    [VDNetRequest VD_PostWithURL:URL arrtribute:paramDic ? @{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:paramDic token:YES]} : nil finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        SZRLog(@"responseObject = %@ error = %@",responseObject,error);
        if (!error) {
            if (![responseObject[RESULT] boolValue]) {
                !showHud ? : VD_ShowBGBackError(YES) ;
                if (CODE_ENUM == TOKEN_OVERDUE && viewController) {
                    [VDUserTools TokenExpire:viewController];
                }
                !failureEndRefresh ? : failureEndRefresh();
            }else{
                
                SZRLog(@"😂需要哪里打印哪里 %@",kBGDataStr);

                if (success) {
                    success(responseObject);
                }
            }
        }else{
            !showHud ? : VD_SHowNetError(YES);
//            SZRLog(@"error %@",error);
            !failureEndRefresh ? : failureEndRefresh();
        }
    } noNetwork:^{
        !showHud ? : VD_SHowNetError(YES);
        !failureEndRefresh ? : failureEndRefresh();
    }];
}

//第三方掌厨
+(void)COOKING_RequestHandle:(NSDictionary *)paramDic
                 viewController:(UIViewController *)viewController
                        success:(void(^)(id responseObject))success
              failureEndRefresh:(void(^)(void))failureEndRefresh
                        showHUD:(BOOL)showHud
                         hudStr:(NSString *)hudStr
{

    if (showHud) {
        [MBProgressHUD showMessage:hudStr];
    }
    [VDNetRequest VD_PostWithURL:COOKINGServiceURL arrtribute:paramDic ? @{VDHTTPPARAMETERS:paramDic} : nil finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if (![responseObject[@"code"] isEqualToString:@"0"]) {
                !showHud ? : [MBProgressHUD showTextOnly:responseObject[@"msg"] hideBeforeShow:YES] ;
                if (CODE_ENUM == TOKEN_OVERDUE && viewController) {
                    [VDUserTools TokenExpire:viewController];
                }
                !failureEndRefresh ? : failureEndRefresh();
            }else{
              
//                SZRLog(@"😂需要哪里打印哪里 %@",[SZRFunction dictionaryToJson:responseObject[@"data"]]);

                if (success) {
                    success(responseObject);
                }
            }
        }else{
            !showHud ? : VD_SHowNetError(YES);
            !failureEndRefresh ? : failureEndRefresh();
        }
    } noNetwork:^{
        !showHud ? : VD_SHowNetError(YES);
        !failureEndRefresh ? : failureEndRefresh();
    }];
 
    
}







@end
