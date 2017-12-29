//
//  RCDataBaseManager.h
//  HeheHealthManager
//
//  Created by SZR on 2017/3/17.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCDataBaseManager : NSObject

+(RCDataBaseManager *)shareInstance;

//存储用户信息
- (void)insertUserToDB:(RCUserInfo *)user;

//从表中获取用户信息
- (RCUserInfo *)getUserByUserId:(NSString *)userId;

// 存储签约状态
- (void)insertUserToDBDoctorId:(NSString *)doctorId code:(NSString* )code;
//查询签约状态
- (NSString* )querySignDoctorStates:(NSString *)doctorId ;

@end












