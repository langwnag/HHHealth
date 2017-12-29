//
//  ZPFDownLoaderManager.m
//  OutputStream-01
//
//  Created by 周先森 on 16/6/9.
//  Copyright © 2016年 周先森. All rights reserved.
//

#import "ZPFDownLoaderManager.h"
#import "ZPFDownLoader.h"

@interface ZPFDownLoaderManager ()
@property(nonatomic,strong)NSMutableDictionary* downLoaderCache;
@end

@implementation ZPFDownLoaderManager
-(NSMutableDictionary *)downLoaderCache {
    if (!_downLoaderCache) {
        _downLoaderCache = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _downLoaderCache;
}

+(instancetype)sharedManager {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [self new];
        
    });
    return instance;
}
//暂停操作
-(void)pause:(NSString *)urlString {
    ZPFDownLoader* downLoader = self.downLoaderCache[urlString];
    
    //判断下载缓存池是否为空
    if (!downLoader) {
        NSLog(@"没有下载操作,无法暂停..");
        return;
    }
    [downLoader pause];
    //在缓存池移除操作
    [self.downLoaderCache removeObjectForKey:urlString];
    
}
-(void)downLoader:(NSString *)urlString successBlock:(void (^)(NSString *))successBlock processBlock:(void (^)(float))processBlock errorBlock:(void (^)(NSError *))errorBlock {

    if (self.downLoaderCache[urlString]) {
        NSLog(@"正在拼命下载...");
        return;
    }
    
    ZPFDownLoader* downLoaer = [ZPFDownLoader downLade:urlString successBlock:^(NSString *path) {
        //移除缓存池的内容
        [self.downLoaderCache removeObjectForKey:urlString];
        
        if (successBlock) {
            successBlock(path);
        }
    } processBlock:processBlock errorBlock:^(NSError *error) {
        //移除缓存池的内容
        [self.downLoaderCache removeObjectForKey:urlString];
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    //把自定义操作放到新队列
    [[NSOperationQueue new]addOperation:downLoaer];
    
    [self.downLoaderCache setObject:downLoaer forKey:urlString];
}
@end
