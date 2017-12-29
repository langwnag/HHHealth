//
//  CareFamilyModel.h
//  YiJiaYi
//
//  Created by mac on 2017/2/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CareFamilyModel : NSObject

@property(nonatomic,strong)NSNumber * vipLevel;
/**
 指数
 */
@property(nonatomic,copy)NSString * index;

/**
 关系（家人）
 */
@property(nonatomic,copy)NSString * relationship;

/**
 名字
 */
@property(nonatomic,copy)NSString * name;

/**
 时间
 */
@property(nonatomic,copy)NSString * time;

/**
 病因
 */
@property(nonatomic,copy)NSString * diseaseResion;

/**
 头像
 */
@property(nonatomic,copy)NSString * icon;

- (instancetype)initWithDict:(NSDictionary* )dict;
+ (instancetype)careFamilyWithDict:(NSDictionary* )dict;





@end
