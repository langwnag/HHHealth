//
//  DoctListModel.h
//  YiJiaYi
//
//  Created by mac on 2016/11/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
@class RCConversationModel;

@interface DoctListModel : JKDBModel


@property(nonatomic,strong)NSNumber * age;
@property(nonatomic,strong)NSNumber * agentCompanyId;
@property(nonatomic,copy)NSString * counselingApproach;

/**
 *  id
 */
@property(nonatomic,copy)NSString * doctorId;

@property(nonatomic,copy)NSString * doctorRCId;

@property(nonatomic,strong)NSNumber * doctorLevelId;

@property(nonatomic,copy)NSString * doctorLocation;

/**
 *  医生类型
 */
@property(nonatomic,copy)NSString * doctorType;
@property(nonatomic,strong)NSNumber * doctorTypeId;

/**
 *  教育背景
 */
@property(nonatomic,copy)NSString * educationalBackground;
/**
 *  擅长领域
 */
@property(nonatomic,copy)NSString * goodField;//不是必填项
/**
 *  医生水平
 */
@property(nonatomic,copy)NSString * hhDoctorLevel;
@property(nonatomic,copy)NSString * identityCard;
@property(nonatomic,copy)NSString * individualResume;
/**
 *  职位名称
 */
@property(nonatomic,copy)NSString * jobTitle;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * phone;
@property(nonatomic,strong)NSNumber * serviceFeeId;
@property(nonatomic,strong)NSNumber * serviceYear;
@property(nonatomic,copy)NSString * sex;
@property(nonatomic,copy)NSString * spiritualMessage;//心灵寄语
@property(nonatomic,copy)NSString * workExperience;

@property(nonatomic,copy)NSString * headPortrait;

@property(nonatomic,copy)NSString * workUnit;

@property(nonatomic,assign)BOOL signState;


-(void)setModelValueWithDic:(NSDictionary *)dic;




@end
