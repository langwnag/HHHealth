//
//  NSString+Path.m
//  zycpNew
//
//  Created by yjcp_mini on 15/6/26.
//  Copyright (c) 2015年 yjyc. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)

+ (NSString *)nofityDataBase
{
    return [[self accountMainPath] stringByAppendingPathComponent:@"default.rdb"];
}
+ (NSString *)accountMainPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
/**
 *  追加文档目录
 */
- (NSString *)appendDocumentDir{
   
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSLog(@"%@",path);
    return [self appendWithPath:path];
}

/**
 *  追加缓存目录
 */
- (NSString *)appendCacheDir{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    return [self appendWithPath:path];
}

/**
 *  追加临时目录
 */
- (NSString *)appendTempDir{
    NSString *path = NSTemporaryDirectory();
    return [self appendWithPath:path];
}

// 在传入的路径后拼接当前的字符串
- (NSString *)appendWithPath:(NSString *)path{
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *currentName = infoDict[@"CFBundleIdentifier"];
    [path stringByAppendingPathComponent:currentName];
    return [path stringByAppendingPathComponent:self];
}

@end
