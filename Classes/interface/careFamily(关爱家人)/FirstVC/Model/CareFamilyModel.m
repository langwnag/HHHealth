//
//  CareFamilyModel.m
//  YiJiaYi
//
//  Created by mac on 2017/2/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CareFamilyModel.h"

@implementation CareFamilyModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        // KVC 模型的属性和字典属性一样
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)careFamilyWithDict:(NSDictionary *)dict{
    
    return [[self alloc]initWithDict:dict];
}


@end
