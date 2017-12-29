//
//  PhaseGramsModel.h
//  YiJiaYi
//
//  Created by mac on 2017/7/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 相宜食材数组
 */
@interface Suitable_with : NSObject
/** 食材图片 */
@property(nonatomic,copy)NSString * image;
/** 食材id */
@property(nonatomic,copy)NSString * material_id;
/** 描述 */
@property(nonatomic,copy)NSString * suitable_desc;
/** 食材名 */
@property(nonatomic,copy)NSString * material_name;
/** 类型 */
@property(nonatomic,copy)NSString * type;
@end

/**
 相克食材数组
 */
@interface Suitable_not_with : NSObject
/** 食材图片 */
@property(nonatomic,copy)NSString * image;
/** 食材id */
@property(nonatomic,copy)NSString * material_id;
/** 描述 */
@property(nonatomic,copy)NSString * suitable_desc;
/** 食材名 */
@property(nonatomic,copy)NSString * material_name;
/** 类型 */
@property(nonatomic,copy)NSString * type;
@end


@interface PhaseGramsModel : NSObject
/** 食材图片 */
@property(nonatomic,copy)NSString * image;
/** 食材id */
@property(nonatomic,copy)NSString * material_id;
/** 食材名 */
@property(nonatomic,copy)NSString * material_name;

/** 相克食材数组 */
@property(nonatomic,copy)NSArray * suitable_not_with;
/** 相宜食材数组 */
@property(nonatomic,copy)NSArray * suitable_with;


@end
