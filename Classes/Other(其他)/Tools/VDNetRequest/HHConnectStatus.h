
//
//  HHConnectStatus.h
//  KBHEHE
//
//  Created by SZR on 2017/1/20.
//  Copyright © 2017年 KeBun. All rights reserved.
//

#ifndef HHConnectStatus_h
#define HHConnectStatus_h

typedef NS_ENUM(NSInteger,HHConnectCode){
    //用户名或密码错误!
    WRONG_PASSWORD,
    //用户信息添加成功!
    USER_INFORMATION_ADDED_SUCCESSFULLY,
    //用户信息修改成功!
    USER_INFORMATION_MODIFY_SUCCESS,
    //用户已经存在!
    USER_ALREADY_EXISTS,
    //短信发送数量达到最大限制!
    TEXT_MESSAGING_QUANTITY_CONTROL,
    //短信发送过于频繁!
    TEXT_MESSAGES_TOO_OFTEN,
    //验证码错误或过期!
    VERIFICATION_CODE_ERROR,
    //您的个人信息已存在!
    DOCTOR_INFORMATION_THERE,
    //请求的回调地址不存在!
    CALLBACK_ADDRESS_DOES_NOT_EXIST,
    //你没有权限操作!
    INSUFFICIENT_USER_PERMISSIONS,
    TOKEN_OVERDUE
};

#define HHConnectCodeStrArr @[@"WRONG_PASSWORD",\
@"USER_INFORMATION_ADDED_SUCCESSFULLY",\
@"USER_INFORMATION_MODIFY_SUCCESS",\
@"USER_ALREADY_EXISTS",\
@"TEXT_MESSAGING_QUANTITY_CONTROL",\
@"TEXT_MESSAGES_TOO_OFTEN",\
@"VERIFICATION_CODE_ERROR",\
@"DOCTOR_INFORMATION_THERE",\
@"CALLBACK_ADDRESS_DOES_NOT_EXIST",\
@"INSUFFICIENT_USER_PERMISSIONS",\
@"TOKEN_OVERDUE"]


#endif /* HHConnectStatus_h */
