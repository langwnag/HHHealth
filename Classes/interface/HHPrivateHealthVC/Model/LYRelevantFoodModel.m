//
//  LYRelevantFoodModel.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYRelevantFoodModel.h"

@implementation LYRelevantFoodModel

+ (NSDictionary<NSString *,Class> *)whc_ModelReplaceContainerElementClassMapper{
    return @{@"data":[LYRelevantData class]};
}

@end

@implementation LYRelevantData

+ (NSDictionary<NSString *,Class> *)whc_ModelReplaceContainerElementClassMapper{
    return @{@"data":[LYRelevantDetailData class]};
}

@end


@implementation LYRelevantDetailData

+ (NSDictionary<NSString *,Class> *)whc_ModelReplaceContainerElementClassMapper{
    return @{@"tags_info":[TagsInfo class]};
}

+ (NSDictionary <NSString *, NSString *> *)whc_ModelReplacePropertyMapper{
    return @{@"description":@"desc"};
}
@end

@implementation TagsInfo

+ (NSDictionary <NSString *, NSString *> *)whc_ModelReplacePropertyMapper{
    return @{@"id":@"tid"};
}
@end





