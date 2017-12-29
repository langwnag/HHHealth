//
//  Request.h
//  YiJiaYi
//
//  Created by MorningStar on 17/12/2017.
//  Copyright © 2017 mac. All rights reserved.
//

#import "BANetManager_OC.h"
#import "HUDHandleTool.h"

@interface Request : NSObject
+ (void)postRequest:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)postRequest:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id json))success stateSuccess:(void (^)(id json))stateSuccess failure:(void (^)(NSError *error))failure;
@end
