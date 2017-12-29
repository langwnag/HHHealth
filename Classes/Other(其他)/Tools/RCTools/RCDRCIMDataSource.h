//
//  RCDRCIMDataSource.h
//  HeheHealthManager
//
//  Created by SZR on 2017/3/17.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RCDDataSource [RCDRCIMDataSource shareInstance]

@interface RCDRCIMDataSource : NSObject<RCIMUserInfoDataSource>

+(RCDRCIMDataSource *)shareInstance;



@end
