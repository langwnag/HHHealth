//
//  RSAEncryptor.h
//  rsaCheshi
//
//  Created by XiaDian on 16/5/5.
//  Copyright © 2016年 vdchina. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface RSAEncryptor : NSObject

#pragma mark - Instance Methods
//RSA加密字符串
-(NSString*) rsaEncryptString:(NSString*)string;
-(NSData*) rsaEncryptData:(NSData*)data ;
//RSA解密字符串
-(NSString*) rsaDecryptString:(NSString*)string;
-(NSData*) rsaDecryptData:(NSData*)data;
+(instancetype)shareManager;
@end