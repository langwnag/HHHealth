//
//  ZPFDownLoaderManager.h
//  OutputStream-01
//
//  Created by 周先森 on 16/6/9.
//  Copyright © 2016年 周先森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPFDownLoaderManager : NSObject
+(instancetype)sharedManager;
-(void)downLoader:(NSString*)urlString successBlock:(void(^)(NSString* path))successBlock processBlock:(void(^)(float process))processBlock errorBlock:(void(^)(NSError* error))errorBlock;
-(void)pause:(NSString*)urlString;
@end
