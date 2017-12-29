//
//  RSAAndDESEncrypt.h
//  客邦
//
//  Created by SZR on 16/5/6.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RSAAndDESEncrypt : NSObject
/**
 *  先用key DES加密字符串 然后RSA加密这个key
 */
+(NSString *)encrypt:(NSString *)str;
+(NSDictionary *)encryptParams:(NSDictionary *)dic token:(BOOL)ret;


/**
 *  先用RSA解密key 然后用key DES解密字符串
 */
+(NSString *)decyrpt:(NSDictionary *)dic;
/**
 *  注册的加密
 */
+ (NSString* )DESEncrypt:(NSString* )str;
/**
 *  其他的解密(包括注册)
 */
+(NSString *)DESDecrypt:(NSString *)str;

/**
 解密后台请求数据
 */
+(id)DESDecryptResponseObject:(NSDictionary *)responseObject;

/**
 *  根据key 和 offSet 解密
 */
+(NSString *)DESPayDecrypt:(NSString *)str key:(NSString *)key offset:(NSString *)offset;

+(id)LYDESDecryptResponseObject:(NSDictionary *)responseObject;
@end
