//
//  IngredientsModel.h
//  YiJiaYi
//
//  Created by mac on 2017/7/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 食材模型
 */

@interface Material : NSObject
/** 食材名 */
@property(nonatomic,copy)NSString * material_name;
/** 食材重 */
@property(nonatomic,copy)NSString * material_weight;
@end

@interface Spices : NSObject
/** 图片 */
@property(nonatomic,copy)NSString * image;
/** 名 */
@property(nonatomic,copy)NSString * title;
@end

@interface IngredientsModel : NSObject
/** 食材数组 */
@property(nonatomic,copy)NSArray * material;
/** 食材大图 */
@property(nonatomic,copy)NSString * material_image;
/** 食材 */
@property(nonatomic,copy)NSArray * spices;

@end
