//
//  HHAddUserInformation.h
//  YiJiaYi
//
//  Created by mac on 2017/4/10.
//  Copyright © 2017年 mac. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HHUserPrivateDoctor.h"
@interface HHAddUserInformation : NSObject
@property (nonatomic,strong) NSArray <HHUserPrivateDoctor* > * userPrivateDoctorArr;


- (instancetype)initWithDic:(NSDictionary* )dic;

@end
