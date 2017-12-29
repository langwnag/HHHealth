//
//  AddressRequest.h
//  YiJiaYi
//
//  Created by LA on 2017/11/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,AddressUrlType){
    AddreseeProvinceType = 1,
    AddressCommunityType,
};

@interface AddressRequest : NSObject
/** RAC*/
@property (nonatomic, strong) RACCommand* addressCommand;
/** pararms*/
@property (nonatomic, strong) NSDictionary* pararms;
/** urlType */
@property (nonatomic, copy) NSString* urlType;
/** 枚举 */
@property (nonatomic, assign) AddressUrlType addressUrlType;
@end
