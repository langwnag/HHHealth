//
//  RCDHttpTool.m
//  HeheHealthManager
//
//  Created by SZR on 2017/3/17.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import "RCDHttpTool.h"

#import "RCDataBaseManager.h"

@implementation RCDHttpTool

+(RCDHttpTool *)shareInstance{
    static RCDHttpTool * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RCDHttpTool alloc]init];
    });
    return instance;
}

//根据userId获取单个用户信息
- (void)getUserInfoByUserID:(NSString *)userID
                 completion:(void (^)(RCUserInfo *user))completion{
    RCUserInfo * userInfo = [[RCDataBaseManager shareInstance]getUserByUserId:userID];
    SZRLog(@"userInfo = %@",userInfo);
    if (!userInfo) {
        //此时网络请求
        [VDNetRequest HH_GetUserInfo:userID success:^(id response) {
            RCUserInfo *user = [RCUserInfo new];
            user.userId = userID;
            user.name = response[@"name"];
            user.portraitUri = response[@"headPortrait"][@"pictureUrl"];
            if (!user.portraitUri || user.portraitUri.length <= 0) {
                user.portraitUri = HHClientRCDefaultPortraitUri;
            }
            [[RCDataBaseManager shareInstance]insertUserToDB:user];
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(user);
                });
            }
            
        } failure:^(NSError *err) {
            SZRLog(@"查询错误");
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    RCUserInfo *user = [RCUserInfo new];
                    user.userId = userID;
                    user.name = [NSString stringWithFormat:@"name%@",[userID substringFromIndex:17]];
                    user.portraitUri = HHClientRCDefaultPortraitUri;
                    completion(user);
                });
            }
        }];
    }else{
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!userInfo.portraitUri || userInfo.portraitUri.length <= 0) {
                    userInfo.portraitUri = HHClientRCDefaultPortraitUri;
                }
                completion(userInfo);
            });
        }
    }
}


@end
