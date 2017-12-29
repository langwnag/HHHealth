//
//  HHUserInformation.h
//  YiJiaYi
//
//  Created by mac on 2016/12/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHUserInformation : NSObject<NSCoding>
/**
 *  出生日期
 */
@property (nonatomic,copy) NSString * dateBirth;

@property (nonatomic,copy) NSString * exerciseFrequency;

/**
 *  高度
 */
@property (nonatomic,strong) NSNumber* height;

@property (nonatomic,strong) NSNumber* isDrink;

@property (nonatomic,strong) NSNumber* isMarry;

@property (nonatomic,strong) NSNumber* isSmoking;

/**
 *  ？ 
 */
@property (nonatomic,copy) NSString* medicalHistory;
/**
 *  名字
 */
@property (nonatomic,copy) NSString* name;
/**
 *  ？
 */
@property (nonatomic,copy) NSString* natureWork;
/**
 *  职位
 */
@property (nonatomic,copy) NSString* position;
/**
 *  地区
 */
@property (nonatomic,copy) NSString* serviceArea;
/**
 *  性别
 */
@property (nonatomic,copy) NSString* sex;
/**
 *  体重
 */
@property (nonatomic,strong) NSNumber* weight;


@end
