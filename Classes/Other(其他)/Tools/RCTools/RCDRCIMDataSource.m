//
//  RCDRCIMDataSource.m
//  HeheHealthManager
//
//  Created by SZR on 2017/3/17.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import "RCDRCIMDataSource.h"

#import "RCDUserInfoManager.h"

@implementation RCDRCIMDataSource

+(RCDRCIMDataSource *)shareInstance{
    static RCDRCIMDataSource * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RCDRCIMDataSource alloc]init];
    });
    return instance;
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *))completion {
    RCUserInfo *user = [RCUserInfo new];
    if (userId == nil || [userId length] == 0) {
        user.userId = userId;
        user.portraitUri = @"";
        user.name = @"";
        completion(user);
        return;
    }
    //开发者调自己的服务器接口根据userID异步请求数据
    [[RCDUserInfoManager shareInstance] getUserInfo:userId  completion:^(RCUserInfo *user) {
        [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:user.userId];
        
        completion(user);
    }];

    return;
}


@end
