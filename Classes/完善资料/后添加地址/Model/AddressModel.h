//
//  AddressModel.h
//  YiJiaYi
//
//  Created by LA on 2017/11/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property (nonatomic, assign) NSInteger addressId;
@property (nonatomic, copy) NSString* code;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* parentCode;
@property (nonatomic, copy) NSString* communityName;

@end
