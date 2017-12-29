//
//  DoctorServiceHomeModel.h
//  YiJiaYi
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorServiceHomeModel : NSObject
/** 其他费用 */
@property (nonatomic,assign) NSInteger otherFee;
/** 服务费用 */
@property (nonatomic,assign) NSInteger serviceFee;
/** 服务类型id */
@property (nonatomic,assign) NSInteger serviceId;
/** 服务名称 */
@property (nonatomic,copy) NSString * serviceName;
@end
