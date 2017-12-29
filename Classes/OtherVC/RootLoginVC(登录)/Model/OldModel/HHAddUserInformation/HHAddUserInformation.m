//
//  HHAddUserInformation.m
//  YiJiaYi
//
//  Created by mac on 2017/4/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHAddUserInformation.h"

@implementation HHAddUserInformation
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        NSMutableArray* arr = [NSMutableArray array];
        for (NSDictionary* subDic in dic[@"userPrivateDoctor"]) {
            HHUserPrivateDoctor* privModel = [[HHUserPrivateDoctor alloc] init];
            [privModel setValuesForKeysWithDictionary:subDic];
            [arr addObject:privModel];
        }
        self.userPrivateDoctorArr = arr;
    }
    return self;
}
@end
