//
//  RCDUserInfoManager.h
//  HeheHealthManager
//
//  Created by SZR on 2017/3/17.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCDUserInfoManager : NSObject

+(RCDUserInfoManager *)shareInstance;

//通过自己的userId获取自己的用户信息
-(void)getUserInfo:(NSString *)userId
        completion:(void (^)(RCUserInfo *))completion;

@end
