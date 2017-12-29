//
//  RelevantModel.h
//  YiJiaYi
//
//  Created by mac on 2017/7/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 相关常识模型
 */
@interface RelevantModel : NSObject
/** 图片 */
@property(nonatomic,copy)NSString * image;
/** 相关常识 */
@property(nonatomic,copy)NSString * nutrition_analysis;
/** 制作指导 */
@property(nonatomic,copy)NSString * production_direction;
@end
