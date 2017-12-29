//
//  FindMacaoDataBase.m
//  FindMacau
//
//  Created by lzd on 2017/5/14.
//  Copyright © 2017年 sinokru. All rights reserved.
//

#import "FindMacaoDataBase.h"
#import "YYCache.h"

@implementation FindMacaoDataBase
static NSString * const USER_INFO_CACHES = @"FindMacaoDataBase";
static YYCache *_dataCache;

+ (void)initialize {
    _dataCache = [YYCache cacheWithName:USER_INFO_CACHES];
}

+ (void)saveObject:(id)object forKey:(NSString *)key {
    [_dataCache setObject:object forKey:key];
}
+ (id)objectForKey:(NSString *)key {
    return [_dataCache objectForKey:key];
}

+ (void)removeForKey:(NSString *)key {
    [_dataCache removeObjectForKey:key];
}
#pragma mark ---- 用户登录信息
//保存最后一次登录的用户信息
+ (void)saveUserinfo:(UserInfoModel *)info {
    [_dataCache setObject:(id)info forKey:@"LAST_USERINFO"];
}
//获取最后一次登录信息
+ (UserInfoModel *)lastUserinfo {
    UserInfoModel *last = (UserInfoModel *)[_dataCache objectForKey:@"LAST_USERINFO"];
    return last;
}

#pragma mark ---- 用户预约信息
//保存最后一条预约信息
+ (void)saveOrderSIMCardUserInfo:(OrderSIMCardUserInfoModel *)info {
    [_dataCache setObject:(id)info forKey:@"LAST_ORDERSIM_USERINFO"];
}
//获取最后一条预约信息
+ (OrderSIMCardUserInfoModel *)lastOrderSIMCardUserInfo {
    OrderSIMCardUserInfoModel *last = (OrderSIMCardUserInfoModel *)[_dataCache objectForKey:@"LAST_ORDERSIM_USERINFO"];
    return last;
}

#pragma mark ---- App首页广告信息
+ (void)saveSplashModel:(SplashAdvModel *)splash {
    [_dataCache setObject:(id)splash forKey:@"LAST_SPLASH_ADV"];
}
+ (SplashAdvModel *)lastSplashModel {
    SplashAdvModel *splash = (SplashAdvModel *)[_dataCache objectForKey:@"LAST_SPLASH_ADV"];
    return splash;
}

#pragma mark ---- 朋友圈展示
+ (void)saveFriendCircleModel:(HHMomentModel *)circleModel{
    [_dataCache setObject:(id)circleModel forKey:@"LAST_FRIEND_CIRCLE"];
}
+ (HHMomentModel *)lastFriendCircleModel{
    HHMomentModel* circle = (HHMomentModel* )[_dataCache objectForKey:@"LAST_FRIEND_CIRCLE"];
    return circle;
}


+ (void)delectUserCacheData {
    [_dataCache removeAllObjects];
}
@end
