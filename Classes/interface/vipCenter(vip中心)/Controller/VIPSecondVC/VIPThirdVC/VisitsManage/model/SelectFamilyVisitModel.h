//
//  SelectFamilyVisitModel.h
//  YiJiaYi
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoctorServiceHomeModel.h"
#import "DoctorInformationModel.h"
@interface SelectFamilyVisitModel : NSObject
/** 医生id */
@property (nonatomic,assign) NSInteger doctorId;
/** 家访id */
@property (nonatomic,assign) NSInteger homeServiceId;
/** 其他服务 */
@property(nonatomic,copy)NSString * otherService;
/** 预约前往的地址 */
@property (nonatomic,copy) NSString * serviceAddress;
/** 联系人 */
@property (nonatomic,copy) NSString * serviceContact;
/** 服务次数 */
@property (nonatomic,assign) NSInteger serviceCount;
/** 服务类型id */
@property (nonatomic,assign) NSInteger serviceId;
/**  服务状态 */
@property (nonatomic,copy) NSString * serviceOrderState;
/** 订单的时间 */
@property (nonatomic,assign) long long serviceOrderTime;
/** 发起服务人电话 */
@property (nonatomic,copy) NSString * servicePhone;
/** 要服务的时间 */
@property (nonatomic,assign) long long serviceTime;
/** 服务价格 */
@property (nonatomic,strong) NSNumber* serviceFee;
/** 用户id */
@property (nonatomic,assign) NSInteger userId;
/** 子模型 */
@property (nonatomic,strong) DoctorServiceHomeModel* doctorServiceHome;
/** 以上信息子模型 */
@property (nonatomic,strong) DoctorInformationModel* doctorInformation;

@end
