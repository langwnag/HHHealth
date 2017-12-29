//
//  MedicalReportModel.h
//  YiJiaYi
//
//  Created by mac on 2017/6/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicalReportModel : NSObject
/** bucketName */
@property(nonatomic,copy)NSString * bucketName;
/** localhostUrl */
@property(nonatomic,copy)NSString * localhostUrl;
/** reportId */
@property(nonatomic,copy)NSString * reportId;
/** reportKey */
@property(nonatomic,copy)NSString * reportKey;
/** 体检时间 */
@property(nonatomic,assign)NSInteger reportTime;
/** 图片地址 */
@property(nonatomic,copy)NSString * reportUrl;
/** type */
@property(nonatomic,copy)NSString * type;
/** 用户id */
@property(nonatomic,copy)NSString * userId;


@end
