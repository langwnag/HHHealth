//
//  DoctorInformationModel.h
//  YiJiaYi
//
//  Created by mac on 2017/5/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorInformationModel : NSObject
/** 医生头像id */
@property (nonatomic,assign) NSInteger doctorPictureId;
/** 医生头像 */
@property(nonatomic,copy)NSString * pictureUrl;
/** 擅长领域 */
@property(nonatomic,copy)NSString * goodField;
/** 名字 */
@property(nonatomic,copy)NSString * name;
/** 性别 */
@property(nonatomic,copy)NSString * sex;

@end
