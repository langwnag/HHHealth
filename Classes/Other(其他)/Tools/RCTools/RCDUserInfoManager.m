//
//  RCDUserInfoManager.m
//  HeheHealthManager
//
//  Created by SZR on 2017/3/17.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import "RCDUserInfoManager.h"
#import "RCDHttpTool.h"
#import "RCDataBaseManager.h"

@implementation RCDUserInfoManager

+(RCDUserInfoManager *)shareInstance{
    static RCDUserInfoManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RCDUserInfoManager alloc]init];
    });
    return instance;
}

//通过自己的userId获取自己的用户信息
-(void)getUserInfo:(NSString *)userId
        completion:(void (^)(RCUserInfo *))completion {
    [RCDHTTPTOOL
     getUserInfoByUserID:userId
     completion:^(RCUserInfo *user) {
         if (user) {
             completion(user);
             return;
         } else {
             user = [[RCDataBaseManager shareInstance] getUserByUserId:userId];
             if (user == nil) {
                 user = [self generateDefaultUserInfo:userId];
             }
             completion(user);
             return;
         }
     }];
}


//设置默认的用户信息
- (RCUserInfo *)generateDefaultUserInfo:(NSString *)userId
{
    RCUserInfo *defaultUserInfo = [RCUserInfo new];
    defaultUserInfo.userId = userId;
    defaultUserInfo.name = [NSString stringWithFormat:@"name%@", userId];
    defaultUserInfo.portraitUri = HHClientRCDefaultPortraitUri;
    return defaultUserInfo;
}

@end
