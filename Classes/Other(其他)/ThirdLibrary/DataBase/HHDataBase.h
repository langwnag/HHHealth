//
//  HHDataBase.h
//  YiJiaYi
//
//  Created by mac on 2017/1/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHDataBase : NSObject
+ (void)saveItemDict:(NSDictionary *)itemDict;
+ (NSArray *)list;
+ (NSArray *)listWithRange:(NSRange)range;
+ (BOOL)isExistWithId:(NSString *)idStr;

@end
