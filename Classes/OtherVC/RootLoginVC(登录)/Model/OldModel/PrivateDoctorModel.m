//
//  PrivateDoctorModel.m
//  YiJiaYi
//
//  Created by SZR on 2017/4/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PrivateDoctorModel.h"

@implementation PrivateDoctorModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"doctorTypeId" : @"doctorInformation.doctorTypeId"
             };
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%zd",self.doctorId];
}


@end
