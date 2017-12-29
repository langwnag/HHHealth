//
//  HHUserToken.h
//  YiJiaYi
//
//  Created by mac on 2016/12/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHUserToken : NSObject<NSCoding>

/**
 创建时间
 */
@property (nonatomic,copy) NSString * createTime;

/**
 token
 */
@property (nonatomic,copy) NSString* token;

@end
