//
//  LYHealthFoodModel.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYHealthFoodModel.h"

@implementation LYHealthFoodModel

+ (NSDictionary<NSString *,Class> *)whc_ModelReplaceContainerElementClassMapper{
    return @{@"data":[LYHealthFoodData class]};
}
@end

@implementation LYHealthFoodData
+ (NSDictionary<NSString *,Class> *)whc_ModelReplaceContainerElementClassMapper{
    return @{@"data":[LYHealthFoodSecData class]};
}

+ (NSDictionary <NSString *, NSString *> *)whc_ModelReplacePropertyMapper{
    return @{@"id":@"secondId"};
}

@end

@implementation LYHealthFoodSecData

+ (NSDictionary<NSString *,Class> *)whc_ModelReplaceContainerElementClassMapper{
    return @{@"data":[LYHealthFoodThridData class]};
}

+ (NSDictionary <NSString *, NSString *> *)whc_ModelReplacePropertyMapper{
    return @{@"id":@"thirdId"};
}

@end

@implementation LYHealthFoodThridData

+ (NSDictionary <NSString *, NSString *> *)whc_ModelReplacePropertyMapper{
    return @{@"id":@"fourId"};
}

@end
