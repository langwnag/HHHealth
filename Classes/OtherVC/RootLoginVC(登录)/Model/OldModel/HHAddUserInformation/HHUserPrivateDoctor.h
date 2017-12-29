//
//  HHUserPrivateDoctor.h
//  YiJiaYi
//
//  Created by mac on 2017/4/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHUserPrivateDoctor.h"

@interface HHUserPrivateDoctor : NSObject
// 创建时间
@property(nonatomic,copy)NSString * createTime;
// doctorId
@property(nonatomic,strong)NSNumber * doctorId;
// 医生信息key:doctorTypeId
@property(nonatomic,strong)NSDictionary * doctorInformation;
// 签约状态
@property(nonatomic,copy)NSString * state;


@end
