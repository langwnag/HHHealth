//
//  LoginModel.h
//  YiJiaYi
//
//  Created by mac on 2016/10/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHUserToken.h"
#import "HHUserAccount.h"
#import "HHUserInformation.h"
#import "HHAddUserInformation.h"
@interface LoginModel : NSObject<NSCoding>

@property (nonatomic,copy)NSString * invitationCode;
@property (nonatomic,copy)NSString* nickname;
@property (nonatomic,copy)NSString * phone;
@property (nonatomic,copy)NSString* state;
@property (nonatomic,copy)NSString* type;
@property (nonatomic,strong)NSNumber * userId;
/**
 *  头像key:pictureUrl
 */
@property (nonatomic,copy)NSString * pictureUrl;
/**
 *  用户账号
 */
@property (nonatomic,strong) HHUserAccount* userAccount;
/**
 *  用户信息
 */
@property (nonatomic,strong) HHUserInformation* userInformation;
/**
 *  用户Token
 */
@property (nonatomic,strong) HHUserToken* userToken;
/**
 *  vip
 */
@property (nonatomic,strong) NSNumber* vipLevel;
/**
 *  后添加签约医生字段
 */
@property (nonatomic,strong) HHAddUserInformation* userPrivateDoctor;

@end
