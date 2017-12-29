//
//  SelectAddressModel.h
//  Zhuan
//
//  Created by LA on 2017/11/1.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectAddressModel : NSObject
/** 市 */
@property (nonatomic, copy) NSArray* citys;
/** 省code */
@property (nonatomic, copy) NSString* provinceCode;
/** 省名字*/
@property (nonatomic, copy) NSString* provinceName;


+ (instancetype)instanceWithDict:(NSDictionary* )dict;

@end
@interface CityModel : NSObject
/** 区域 */
@property (nonatomic, copy) NSArray* areas;
/** 市code */
@property (nonatomic, copy) NSString* cityCode;
/** 市名字*/
@property (nonatomic, copy) NSString* cityName;

@property (nonatomic, copy) NSString* fullAdressString;

@end

@interface AreasModel : NSObject
/** 区域code */
@property (nonatomic, copy) NSString* areaCode;
/** 区域名字*/
@property (nonatomic, copy) NSString* areaName;
/** 状态*/
@property (nonatomic, strong) NSNumber* status;

//@property (nonatomic, copy) NSString* fullAdressString;
@end
