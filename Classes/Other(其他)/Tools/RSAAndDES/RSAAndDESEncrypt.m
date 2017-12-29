//
//  RSAAndDESEncrypt.m
//  客邦
//
//  Created by SZR on 16/5/6.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "RSAAndDESEncrypt.h"
//加密头文件
#import "RSAEncryptor.h"
#import "DESEncrypt.h"

#define DATA @"data" //数据
#define KEY @"key"   //key

#define LoginOffset @"59721567" //RSA+DES 偏移量

#define RegisterOffset @"21684319" //注册偏移量

#define RegisterKey @"685214698462879215698713" //注册key

@implementation RSAAndDESEncrypt

/**
 *  先用key DES加密字符串 然后RSA加密这个key
 */
+(NSString *)encrypt:(NSString *)str{
    
    NSString * key = [SZRFunction randomKey];
//    NSLog(@"❤️❤️:%@",key);
    NSString * desEncryptStr = [DESEncrypt DESEncrypt:str key:key offset:LoginOffset];
    NSString * encryptKey = [[RSAEncryptor shareManager] rsaEncryptString:key];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:desEncryptStr,@"data",encryptKey,@"key",nil];
    
//    NSLog(@"RSA加密:%@",@{DATA:desEncryptStr,KEY:encryptKey});
    NSString* returnStr = [SZRFunction dictionaryToJson:dic];
   
    //去掉下斜杠
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    
    return returnStr;
}

+(NSDictionary *)encryptParams:(NSDictionary *)dic token:(BOOL)ret{
    //    [VDUserTools VD_GetToken],@"token"
    NSString * encryptStr = [self encrypt:[SZRFunction dictionaryToJson:dic]];
    if (ret) {

        return @{@"data":encryptStr,@"token":[VDUserTools VD_GetToken]};
    }else{
        return @{@"data":encryptStr};
    }
    
}



/**
 *  先用RSA解密key 然后用key DES解密字符串
 */
+(NSString *)decyrpt:(NSDictionary *)dic{
//    NSDictionary * dic = [SZRFunction dictionaryWithJsonString:str];
    NSString * decryptKey = [[RSAEncryptor shareManager]rsaDecryptString:dic[KEY]];
    NSString* desDecryptStr = [DESEncrypt DESDecrypt:dic[DATA] key:decryptKey offset:LoginOffset];
    return desDecryptStr;
}
/**
 *  注册加密
 */
+ (NSString *)DESEncrypt:(NSString *)str
{

    return [DESEncrypt DESEncrypt:str key:RegisterKey offset:RegisterOffset];
}

//解密
+(NSString *)DESDecrypt:(NSString *)str{
    return [DESEncrypt DESDecrypt:str key:RegisterKey offset:RegisterOffset];
}

+(id)DESDecryptResponseObject:(NSDictionary *)responseObject{
    return [SZRFunction dictionaryWithJsonString:[self DESDecrypt:responseObject[@"data"]]] ;
}

+(id)LYDESDecryptResponseObject:(NSDictionary *)responseObject{
    id obj = [SZRFunction dictionaryWithJsonString:[self DESDecrypt:responseObject[@"data"]]];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
    [dic setObject:obj forKey:@"data"];
    return dic;
}

//根据 key 和 偏移量 解密
+(NSString *)DESPayDecrypt:(NSString *)str key:(NSString *)key offset:(NSString *)offset{
    return [DESEncrypt DESDecrypt:str key:key offset:offset];
}



@end
