//
//  RCDHttpTool.h
//  HeheHealthManager
//
//  Created by SZR on 2017/3/17.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RCDHTTPTOOL [RCDHttpTool shareInstance]

@interface RCDHttpTool : NSObject

+(RCDHttpTool *)shareInstance;

//获取个人信息
- (void)getUserInfoByUserID:(NSString *)userID
                 completion:(void (^)(RCUserInfo *user))completion;

@end
