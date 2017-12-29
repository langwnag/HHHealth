//
//  FindMacaoDataBase.h
//  FindMacau
//
//  Created by lzd on 2017/5/14.
//  Copyright © 2017年 sinokru. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfoModel;
@class OrderSIMCardUserInfoModel;
@class SplashAdvModel;
@class HHMomentModel;
@interface FindMacaoDataBase : NSObject

+ (void)saveObject:(id)object forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
+ (void)removeForKey:(NSString *)key;

+ (void)saveUserinfo:(UserInfoModel *)info;
+ (UserInfoModel *)lastUserinfo;

+ (void)saveOrderSIMCardUserInfo:(OrderSIMCardUserInfoModel *)info;
+ (OrderSIMCardUserInfoModel *)lastOrderSIMCardUserInfo;

+ (void)saveSplashModel:(SplashAdvModel *)splash;
+ (SplashAdvModel *)lastSplashModel;

+ (void)saveFriendCircleModel:(HHMomentModel* )circleModel;
+ (HHMomentModel* )lastFriendCircleModel;

+ (void)delectUserCacheData;
@end
