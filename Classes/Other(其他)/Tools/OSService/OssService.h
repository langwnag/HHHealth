//
//  OssService.h
//  OssIOSDemo
//
//  Created by 凌琨 on 15/12/15.
//  Copyright © 2015年 Ali. All rights reserved.
//

#ifndef OssService_h
#define OssService_h
#import <AliyunOSSiOS/OSSService.h>

/**
 回调
 NSInteger 0 失败 1 成功 2 任务取消
 */
typedef void(^OssServiceBlock)(NSInteger caseNum,NSString * imageURL);


@interface OssService : NSObject

@property(nonatomic,strong)NSData * imageData;
@property(nonatomic,copy)OssServiceBlock ossServiceBlock;


+(instancetype)shareInstance;
-(void)loadWithDic:(NSDictionary *)dic;

- (id)initWithEndPoint:(NSString *)enpoint;

- (void)setCallbackAddress:(NSString *)address;

-(void)putImages:(NSArray *)photoArr block:(OssServiceBlock)block;


- (void)asyncGetImage:(NSString *)objectKey;

- (void)normalRequestCancel;

@end

#endif /* OssService_h */
