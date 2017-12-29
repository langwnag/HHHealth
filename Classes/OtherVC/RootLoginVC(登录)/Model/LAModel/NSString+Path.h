//
//  NSString+Path.h
//  zycpNew
//
//  Created by yjcp_mini on 15/6/26.
//  Copyright (c) 2015年 yjyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

+ (NSString *)nofityDataBase;
/**
 *  追加文档目录
 */
- (NSString *)appendDocumentDir;

/**
 *  追加缓存目录
 */
- (NSString *)appendCacheDir;

/**
 *  追加临时目录
 */
- (NSString *)appendTempDir;


@end
