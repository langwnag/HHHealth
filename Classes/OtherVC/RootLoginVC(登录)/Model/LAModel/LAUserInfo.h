//
//  LAUserInfo.h
//  YiJiaYi
//
//  Created by MorningStar on 17/12/2017.
//  Copyright © 2017 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAUserInfo : NSObject
@property (nonatomic, assign) NSInteger information;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * registered_time;
@property (nonatomic, strong) NSString * registered_type;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * user_id;

@property (nonatomic, strong) NSString * password;
- (void)save;
+ (instancetype)userInfo;
@end
