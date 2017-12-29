//
//  OssService.m
//  OssIOSDemo
//
//  Created by 凌琨 on 15/12/15.
//  Copyright © 2015年 Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AliyunOSSiOS/OSSService.h>
#import "OssService.h"

#define Content_TypeDic @{@"docx":@"application/msword",@"mp3":@"audio/mp3",@"mp4":@"video/mp4",@"gif":@"image/gif"}

NSString * const bucketName = @"hehe-resource";
NSString * const CALLBACKURL = @"callbackUrl";
NSString * const CALLBACKTYPE = @"callbackType";
NSString * const FILELOCATION = @"fileUploadingLocation";


@implementation OssService
{
    OSSClient * client;
    NSString * endPoint;
    NSString * callbackAddress;
    NSString * _fileLocation;
    NSString * _callBackType;
    OSSPutObjectRequest * putRequest;
    OSSGetObjectRequest * getRequest;
    NSInteger _photoCount;
}

+(instancetype)shareInstance{
    static OssService * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [OssService new];
        [instance endpoint];
        [instance ossInit];
    });
    return instance;
}



-(void)loadWithDic:(NSDictionary *)dic{
    
    callbackAddress = dic[CALLBACKURL];
    _fileLocation = dic[FILELOCATION];
    _callBackType = dic[CALLBACKTYPE];
}


- (id)initWithEndPoint:(NSString *)enpoint {
    if (self = [super init]) {
        endPoint = enpoint;
        [self ossInit];
    }
    return self;
}

/**
 *	@brief	获取FederationToken
 */
- (OSSFederationToken *) getFederationToken {
    OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
    NSURLSessionTask * sessionTask = [VDNetRequest VD_PostWithURL:OSSSTSServer arrtribute:@{VDHTTPPARAMETERS:@{@"token":[VDUserTools VD_GetToken]}} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            [tcs setError:error];
            return;
        }
        [tcs setResult:responseObject];
    }];
    [sessionTask resume];

    // 实现这个回调需要同步返回Token，所以要waitUntilFinished
    [tcs.task waitUntilFinished];
    if (tcs.task.error) {
        return nil;
    } else {
        
        NSDictionary * object = [RSAAndDESEncrypt DESDecryptResponseObject:tcs.task.result];
        SZRLog(@"tcs.task.result = %@",object);
        
        OSSFederationToken * token = [OSSFederationToken new];
        token.tAccessKey = [object objectForKey:@"accessKeyId"];
        token.tSecretKey = [object objectForKey:@"accessKeySecret"];
        token.tToken = [object objectForKey:@"securityToken"];
        token.expirationTimeInGMTFormat = [object objectForKey:@"expiration"];
        SZRLog(@"😊😊AccessKey: %@ \n SecretKey: %@ \n Token:%@ expirationTime: %@ \n",
              token.tAccessKey, token.tSecretKey, token.tToken, token.expirationTimeInGMTFormat);
        
        return token;
    }
    
}

/**
 *	@brief	初始化获取OSSClient
 */
- (void)ossInit {
    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        return [self getFederationToken];
    }];
    client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential];
}


/**
 *	@brief	设置server callback地址
 */
- (void)setCallbackAddress:(NSString *)address {
    callbackAddress = address;
}

#pragma mark 我现在用

-(void)putImages:(NSArray *)photoArr block:(OssServiceBlock)block{
    self.ossServiceBlock = block;
    SZRLog(@"🐦🐦self.ossServiceBlock = %@",self.ossServiceBlock);
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = photoArr.count;
    _photoCount = photoArr.count;
    [photoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                [self asyncPutData:obj index:idx];
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
    }];
}



-(void)asyncPutData:(id)data index:(NSInteger)index{
    putRequest = [OSSPutObjectRequest new];
    putRequest.bucketName = bucketName;
    
    if ([data isKindOfClass:[UIImage class]]) {
        putRequest.contentType = @"image/jpeg";
//        putRequest.objectMeta = @{@"x-oss-meta-height":@"600", @"x-oss-meta-width":@"300"};
        //key前面加一个文件夹名字
        putRequest.objectKey = [NSString stringWithFormat:@"%@%@.jpg",_fileLocation,[NSUUID UUID].UUIDString];
        SZRLog(@"1️⃣putRequest.objectKey = %@",putRequest.objectKey);
        putRequest.uploadingData = UIImageJPEGRepresentation(data, 0.3);
    }else{
        NSString * fileSuffix = [(NSString *)data pathExtension];
        putRequest.contentType = Content_TypeDic[fileSuffix];
        putRequest.objectKey = [NSString stringWithFormat:@"%@%@.%@",_fileLocation,[NSUUID UUID].UUIDString,fileSuffix];
        putRequest.uploadingFileURL = [NSURL fileURLWithPath:data];
    }
    putRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
    };
    if (callbackAddress != nil) {
        //添加key   x:ID
        NSDictionary * dic = @{@"x:key":putRequest.objectKey,@"x:type":_callBackType,@"x:bucketName":putRequest.bucketName,@"x:id":[DEFAULTS objectForKey:CLIENTID]};
        NSLog(@"body = %@",[self dictionaryToJson:dic]);
        putRequest.callbackParam = @{
                                     @"callbackUrl": callbackAddress,
                                     @"callbackBody": [self dictionaryToJson:dic]
                                     };
    }
    
    OSSTask * task = [client putObject:putRequest];

    [task continueWithBlock:^id(OSSTask *task) {
        OSSPutObjectResult * result = task.result;
        // 查看server callback是否成功
        if (!task.error) {
            NSLog(@"Put image success!");
            NSLog(@"server callback : %@   httpResponseCode = %zd", result.serverReturnJsonString,result.httpResponseCode);
            if (index == _photoCount-1 && self.ossServiceBlock) {
                NSString * imageURL = putRequest.objectKey;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.ossServiceBlock(1,[NSString stringWithFormat:@"%@%@",OSSImagePrefixURL,imageURL]);
                });
            }
            
        } else {
            NSLog(@"Put image failed, %@", task.error);
            if (self.ossServiceBlock && task.error.code == OSSClientErrorCodeTaskCancelled) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.ossServiceBlock(2,nil);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                   self.ossServiceBlock(0,nil);
                });
            }
        }
        putRequest = nil;
        return nil;
    }];
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


/**
 *	@brief	下载图片
 */
- (void)asyncGetImage:(NSString *)objectKey {
    if (objectKey == nil || [objectKey length] == 0) {
        return;
    }
    getRequest = [OSSGetObjectRequest new];
    getRequest.bucketName = bucketName;
    getRequest.objectKey = objectKey;
    OSSTask * task = [client getObject:getRequest];
    [task continueWithBlock:^id(OSSTask *task) {
        OSSGetObjectResult * result = task.result;
        if (!task.error) {
            NSLog(@"Get image success!");
            dispatch_async(dispatch_get_main_queue(), ^{
//                [viewController saveAndDisplayImage:result.downloadedData downloadObjectKey:objectKey];
//                [viewController showMessage:@"普通下载" inputMessage:@"Success!"];
            });
        } else {
            NSLog(@"Get image failed, %@", task.error);
            if (task.error.code == OSSClientErrorCodeTaskCancelled) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [viewController showMessage:@"普通下载" inputMessage:@"任务取消!"];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [viewController showMessage:@"普通下载" inputMessage:@"Failed!"];
                });
            }
        }
        getRequest = nil;
        return nil;
    }];
}



/**
 *	@brief	普通上传/下载取消
 */
- (void)normalRequestCancel {
    if (putRequest) {
        [putRequest cancel];
    }
    if (getRequest) {
        [getRequest cancel];
    }
}


-(void)endpoint{
    endPoint = OSSEndPoint;
}

@end
