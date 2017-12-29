//
//  LYMaterialDetailModel.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYMaterialDetailModel.h"

@implementation LYMaterialDetailModel

+ (NSDictionary<NSString *,Class> *)whc_ModelReplaceContainerElementClassMapper{
    return @{@"data":[LYMaterialDetailData class]};
}

@end

@implementation LYMaterialDetailData

@end

