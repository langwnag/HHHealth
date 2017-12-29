//
//  DESEncrypt.h
//  客邦
//
//  Created by SZR on 16/5/6.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESEncrypt : NSObject
// 加密方法
+ (NSString*)DESEncrypt:(NSString*)plainText key:(NSString *)key offset:(NSString* )offset;

// 解密方法
+ (NSString*)DESDecrypt:(NSString*)encryptText key:(NSString *)key offset:(NSString* )offset;

@end
