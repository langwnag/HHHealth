//
//  DoctorInformationModel.m
//  YiJiaYi
//
//  Created by mac on 2017/5/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DoctorInformationModel.h"

@implementation DoctorInformationModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"pictureUrl":@"headPortrait.pictureUrl"
             };
}

@end
