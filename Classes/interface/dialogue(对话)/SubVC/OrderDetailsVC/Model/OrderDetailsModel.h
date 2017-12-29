//
//  OrderDetailsModel.h
//  YiJiaYi
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHDoctorServiceHomeModel.h"
@interface OrderDetailsModel : NSObject

/** homeServiceId */
@property (nonatomic,assign) NSInteger homeServiceId;
/** 其他服务 */
@property(nonatomic,copy)NSString * otherService;
/** 服务地址 */
@property(nonatomic,copy)NSString * serviceAddress;
/** 联系人 */
@property(nonatomic,copy)NSString * serviceContact;
/** 服务数量 */
@property(nonatomic,assign)NSInteger  serviceCount;
/** 服务费用 */
@property(nonatomic,assign)CGFloat  serviceFee;
/** serviceId */
@property (nonatomic,assign) NSInteger serviceId;
/** 服务状态 */
@property (nonatomic,copy) NSString * serviceOrderState;
/** 订单时间 */
@property(nonatomic,assign)NSInteger serviceOrderTime;
/** 服务电话 */
@property(nonatomic,copy)NSString * servicePhone;
/** 用户id */
@property(nonatomic,assign)NSInteger userId;

/** model */
@property (nonatomic,strong) HHDoctorServiceHomeModel* doctorServiceHome;



@end
