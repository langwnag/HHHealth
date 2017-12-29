//
//  SelectAddressModel.m
//  Zhuan
//
//  Created by LA on 2017/11/1.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "SelectAddressModel.h"
#import <MJExtension/MJExtension.h>
@implementation SelectAddressModel
+ (void)load {
    [SelectAddressModel mj_setupObjectClassInArray:^NSDictionary * {
        return @{
                 @"citys": @"CityModel"
                 };
    }];
}

+ (instancetype)instanceWithDict:(NSDictionary *)dict{
    SelectAddressModel* s = [[self alloc] init];
    [s setValuesForKeysWithDictionary:dict];
    return s;
}

@end

@implementation CityModel
+ (void)load{
    [CityModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"areas":@"AreasModel"
                 };
    }];
    
}

@end

@implementation AreasModel
@end
