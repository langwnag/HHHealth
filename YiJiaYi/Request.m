//
//  Request.m
//  YiJiaYi
//
//  Created by MorningStar on 17/12/2017.
//  Copyright © 2017 mac. All rights reserved.
//

#import "Request.h"

@implementation Request
+ (void)postRequest:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"http://hhadmin.test6.tisapi.com/%@", urlString];
    entity.parameters = parameters;
    //    entity.needCache = whether;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        HideHUD();
        if (success) {
            if ([[response[@"code"] stringValue] isEqualToString:@"100"]) {
                success(response);
            } else {
                [MBProgressHUD showTextOnly:response[@"msg"] hideBeforeShow:YES];
            }
        }
    } failureBlock:^(NSError *error) {
        HideHUD();
        failure(error);
        VD_SHowNetError(YES);
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {}];
}

+ (void)postRequest:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id json))success stateSuccess:(void (^)(id json))stateSuccess failure:(void (^)(NSError *error))failure {
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"http://hhadmin.test6.tisapi.com/%@", urlString];
    entity.parameters = parameters;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        HideHUD();
        if (success) {
            if ([[response[@"code"] stringValue] isEqualToString:@"100"]) {
                success(response);
            } else {
                [MBProgressHUD showTextOnly:response[@"msg"] hideBeforeShow:YES];
                stateSuccess(response);
            }
        }
    } failureBlock:^(NSError *error) {
        HideHUD();
        failure(error);
        VD_SHowNetError(YES);
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {}];
}
@end
