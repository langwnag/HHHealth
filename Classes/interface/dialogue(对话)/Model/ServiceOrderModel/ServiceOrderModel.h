//
//  ServiceOrderModel.h
//  YiJiaYi
//
//  Created by SZR on 2017/3/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceOrderModel : NSObject

@property(nonatomic,copy)NSString * orderTime;
@property(nonatomic,copy)NSString * address;
@property(nonatomic,copy)NSString * linkMan;
@property(nonatomic,copy)NSString * phoneNum;
@property(nonatomic,copy)NSString * serviceType;
@property(nonatomic,copy)NSString * otherService;
@property(nonatomic,assign)double servicePrice;
@property(nonatomic,copy)NSString * coupon;//优惠券
@property(nonatomic,assign)double otherNeedPay;



@end
