//
//  NSString+ClearCaches.m
//  StoryYourself
//
//  Created by 李晓宁 on 15-12-14.
//  Copyright (c) 2015年 beyond. All rights reserved.
//

#import "NSString+ClearCaches.h"

@implementation NSString (ClearCaches)
+(void)clearCaches:(NSString *)path
{
    NSFileManager *manger=[NSFileManager defaultManager];
    BOOL isFile;
    BOOL isExist=[manger fileExistsAtPath:path isDirectory:&isFile];
    if (isExist) {
        if (!isFile) {
            [manger removeItemAtPath:path error:nil];
        }
        else
        {
            NSArray *childrenFiles=[manger subpathsAtPath:path];
            for (NSString *str in childrenFiles) {
                NSString *children=[path stringByAppendingPathComponent:str];
                [manger removeItemAtPath:children error:nil];
            }
        }
    }
}

+(CGFloat)sizeCaches:(NSString *)path
{
    long long size=0;
    NSFileManager *manger=[NSFileManager defaultManager];
    BOOL isFile;
    BOOL isExist=[manger fileExistsAtPath:path isDirectory:&isFile];
    if (isExist) {
        if (!isFile) {
            size=[manger attributesOfItemAtPath:path error:nil].fileSize;
            return size/1000.0/1000.0;
        }
        else
        {
            NSArray *childrenFiles=[manger subpathsAtPath:path];
            
            for (NSString *str in childrenFiles) {
//                NSLog(@"%@",str);
                NSString *children=[path stringByAppendingPathComponent:str];
                size+=[manger attributesOfItemAtPath:children error:nil].fileSize;
            }
            return size/1000.0/1000.0;
        }
    }
    return 0;
}
@end
