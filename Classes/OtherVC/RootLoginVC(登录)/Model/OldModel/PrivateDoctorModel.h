//
//  PrivateDoctorModel.h
//  YiJiaYi
//
//  Created by SZR on 2017/4/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "JKDBModel.h"

@interface PrivateDoctorModel : JKDBModel


@property(nonatomic,assign)int doctorId;
@property(nonatomic,assign)int doctorTypeId;
@property(nonatomic,copy)NSString * state;// -1 0 1



@end
