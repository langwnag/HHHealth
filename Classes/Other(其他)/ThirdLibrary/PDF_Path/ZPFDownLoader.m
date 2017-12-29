//
//  ZPFDownLoader1.m
//  OutputStream-01
//
//  Created by 周先森 on 16/6/9.
//  Copyright © 2016年 周先森. All rights reserved.
//

#import "ZPFDownLoader.h"

@interface ZPFDownLoader  ()
@property(nonatomic,assign)long long expectedContentLength;
@property(nonatomic,assign)long long currentLength;
@property(nonatomic,copy)NSString* filePath;
@property(nonatomic,strong)NSOutputStream* stream;
@property(nonatomic,strong)NSURLConnection* conon;
@property(nonatomic,copy)NSString* urlString;
@property(nonatomic,copy)void(^successBlock)(NSString* path);
@property(nonatomic,copy)void(^processBlock)(float process);
@property(nonatomic,copy)void(^errorBlock)(NSError* error);
@end

@implementation ZPFDownLoader
//暂停操作
-(void)pause {
    //取消操作
    [self.conon cancel];
    //取消任务
    [self cancel];
}
-(void)main {
    @autoreleasepool {
        
        NSURL* url = [NSURL URLWithString:self.urlString];
        //获取文件信息
        [self getServerFileInfo:url];
        if (self.isCancelled) {
            return;
        }
//         自己备注（关于打印了两次）
//        它需要跟服务器的上文件作比对啊  一样的话就不去下载的,直接返回路径
//        从下载速度上也能看出来,一下次的时候,下载进度还看得出来,第二次打开的时候基本上就是秒开了
        //获取本地文件,比较服务器文件的大小
        
        self.currentLength = [self checkLoaderFile];
        if (self.currentLength == -1) {
        
            NSLog(@"文件已下载完毕,不要重复下载..");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.successBlock(self.filePath);
            });
            return;
        }
        if (self.isCancelled) {
            return;
        }
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        [request setValue:[NSString stringWithFormat:@"bytes=%lld-",self.currentLength] forHTTPHeaderField:@"Range"];
        NSURLConnection* conon = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        self.conon = conon;
        [[NSRunLoop currentRunLoop]run];
    }
    
}

//调用对象的方法
+(instancetype)downLade:(NSString*)urlString successBlock:(void(^)(NSString* path))successBlock processBlock:(void(^)(float process))processBlock errorBlock:(void(^)(NSError* error))errorBlock{
    
    ZPFDownLoader* downLoader = [ZPFDownLoader new];
    downLoader.urlString = urlString;
    downLoader.successBlock = successBlock;
    downLoader.processBlock = processBlock;
    downLoader.errorBlock = errorBlock;
    return downLoader;
   
}

//比较文件的大小
-(long long)checkLoaderFile{
    long long fileSize = 0;
    
    NSFileManager* maneger = [NSFileManager defaultManager];
    
    //如果文件存在,获取文件大小
    if ([maneger fileExistsAtPath:self.filePath]) {
        //获取本地文件大小
        NSDictionary* attrs = [maneger attributesOfItemAtPath:self.filePath error:NULL];
        fileSize = attrs.fileSize;
        if (fileSize == self.expectedContentLength) {
            //下载完成
            fileSize = -1;
        }
        if (fileSize > self.expectedContentLength)  {
            
            fileSize = 0;
            //删除文件
            [maneger removeItemAtPath:self.filePath error:NULL];
        }
        
    }
    return fileSize;
}


//获取文件的信息
-(void)getServerFileInfo:(NSURL*)url {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"HEAD";
    NSURLResponse* response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    //获取服务器的文件信息
    self.expectedContentLength = response.expectedContentLength;
    
    self.filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
}

//实现代理方法
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //创建流
    self.stream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:YES];
    //打开流
    [self.stream open];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [NSThread sleepForTimeInterval:0.25];
    
    self.currentLength += data.length;
    
    float process = self.currentLength * 1.0 / self.expectedContentLength;
    //返回进度
    if (self.processBlock) {
        
        self.processBlock(process);
    }
    
    //写入文件,保存数据
    [self.stream write:data.bytes maxLength:data.length];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {

    //关闭流
    [self.stream close];
    
    //下载完成,返回文档本地路径
    if (self.successBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.successBlock(self.filePath);
        });
        
    }
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if(self.errorBlock){
        self.errorBlock(error);
    }
}

@end
