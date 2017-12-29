//
//  VDNetRequest.h
//  客邦
//
//  Created by SZR on 16/4/27.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "HHConnectStatus.h"

extern NSString * const VDHTTPPARAMETERS;   //HTTP post请求参数
extern NSString * const VDHTTPCONTENTTYPE; //HTTP Content-type
extern NSString * const VDHTTPIMAGEARR;       //HTTP 上传图片数组
extern NSString * const VDBGIMAGENAMEARR;     //后台接收的字段/参数
extern NSString * const VDFILEPATH;        //文件路径
extern NSString * const VDBGFILENAME;      //后台接受文件字段/参数
extern NSString * const VDCACHEPATH;       //缓存路径

/**
 *  网络请求完成回调
 *
 *  @param task           任务对象
 *  @param responseObject 请求数据信息
 *  @param error          请求错误信息
 */
typedef void(^VDHttpFinishBlock)(NSURLSessionDataTask * task, id responseObject,NSError * error);

typedef void(^NONetworkBlock)();

// 新添加带缓存网络请求
typedef void (^NeedCache)(BOOL needCache);


@interface VDNetRequest : NSObject

/**
 HTTPS
 
 @return 加密数据
 */
+ (AFSecurityPolicy* )customSecurityPolicy;


/**
 *  普通get请求
 *
 
 *  @param url        请求URL
 *  @param arrtribute 参数列表
 *  @param finish     请求完成回调
 */
+(NSURLSessionDataTask *)VD_GetWithURL:(NSString * )url
                            arrtribute:(NSDictionary *)arrtribute
                                finish:(VDHttpFinishBlock)finish;

+(void)VD_GetWithURL:(NSString * )url
          arrtribute:(NSDictionary *)arrtribute
              finish:(VDHttpFinishBlock)finish
           noNetwork:(NONetworkBlock)noNetwork;

/**
 *  普通post请求
 *
 *  @param url        请求URL
 *  @param arrtribute 参数列表
 *  @param finish     请求完成回调
 */
+(NSURLSessionDataTask *)VD_PostWithURL:(NSString * )url
                             arrtribute:(NSDictionary *)arrtribute
                                 finish:(VDHttpFinishBlock)finish;

+(void)VD_PostWithURL:(NSString * )url
           arrtribute:(NSDictionary *)arrtribute
               finish:(VDHttpFinishBlock)finish
            noNetwork:(NONetworkBlock)noNetwork;

/**
 *  带缓存的post请求
 *
 *  @param url        请求URL
 *  @param arrtribute 参数列表
 *  @param cache      是否缓存
 *  @param finish     请求完成回调
 */+(NSURLSessionDataTask *)VD_PostWithURL:(NSString *)url
                             arrtribute:(NSDictionary *)arrtribute
                                  cache:(BOOL)cache
                                 finish:(VDHttpFinishBlock)finish;


/**
 post请求进一步封装
 */
+(void)HH_RequestHandle:(NSDictionary *)paramDic
                    URL:(NSString *)URL
         viewController:(UIViewController *)viewController
                success:(void(^)(id responseObject))success
      failureEndRefresh:(void(^)(void))failureEndRefresh
                showHUD:(BOOL)showHud
                 hudStr:(NSString *)hudStr;


/**
 *  带缓存的post请求
 *
 *  @param url            请求URL
 *  @param arrtribute     参数列表
 *  @param finish         请求完成回调
 *  @param isCache        是否缓存
 *  @param isFirstRequest 是否第一次请求
 */
+(void)VD_PostWithCache:(NSString *)url
             arrtribute:(NSDictionary *)arrtribute
                 finish:(VDHttpFinishBlock)finish
                isCache:(BOOL)isCache
         isFirstRequest:(BOOL)isFirstRequest;



+(void)VD_OSSImageView:(UIImageView *)imageView
            fullURLStr:(NSString *)URLStr
     placeHolderrImage:(NSString *)placeHolderImage;

/*清理缓存*/
+ (void)clearCaches;

/*获取网络缓存文件大小*/
+ (float)getCacheFileSize;


/**
 请求融云token
 */
+(void)VD_GetRongCloudToken:(void(^)(NSDictionary * dic))success
                    BGError:(void(^)(id responseObject))BGError
                      Error:(void(^)())Error;
/**
 请求HH token
 */
+(void)VD_GetHHToken:(void(^)(NSDictionary * dic))success
             BGError:(void(^)(id responseObject))BGError
               Error:(void(^)())Error;

+(void)HH_GetUserInfo:(NSString *)userId
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;

+(void)HH_UpdateNickNameRequest:(NSDictionary *)paramDic
                        success:(void(^)(NSDictionary * dic))success
                 viewController:(UIViewController *)viewController;

+(void)HH_UpdateUserInfoRequest:(NSDictionary *)paramDic
                        success:(void(^)(NSDictionary * dic))success
                 viewController:(UIViewController *)viewController;
+(BOOL)haveNet;

+(void)HH_CommitSign:(NSString *)doctorID
             success:(void(^)(NSDictionary * dic))success
      viewController:(UIViewController *)viewController
             showHud:(BOOL)showHud;

+(void)HH_GetServiceType:(NSDictionary *)paramDic
          viewController:(UIViewController *)viewController
                 success:(void(^)(NSArray *))success;

+(void)HH_SelectFamilyVisit:(NSDictionary * )paramDic
                    success:(void(^)(NSArray * arr))success
                    BGError:(void(^)(id responseObject))BGError
                 endRefresh:(void(^)(void))endRefresh
             viewController:(UIViewController *)viewController;

+(void)COOKING_RequestHandle:(NSDictionary *)paramDic
              viewController:(UIViewController *)viewController
                     success:(void(^)(id responseObject))success
           failureEndRefresh:(void(^)(void))failureEndRefresh
                     showHUD:(BOOL)showHud
                      hudStr:(NSString *)hudStr;







@end
