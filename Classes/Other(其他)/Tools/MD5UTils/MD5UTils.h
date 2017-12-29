//
//  MD5UTils.h
//  SmartDivce
//
//  Created by feng on 2017/6/9.
//  Copyright © 2017年 冯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#define FileHashDefaultChunkSizeForReadingData 1024*8 // 8K

@interface MD5UTils : NSObject

//计算NSData 的MD5值
+(NSString*)getMD5WithData:(NSData*)data;

//计算字符串的MD5值，
+(NSString*)getmd5WithString:(NSString*)string;

@end
