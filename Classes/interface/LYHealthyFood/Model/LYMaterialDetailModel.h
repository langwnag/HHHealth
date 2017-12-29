//
//  LYMaterialDetailModel.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/12.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <Foundation/Foundation.h>
#import "NSObject+WHC_Model.h"

/**
 选购要诀、营养功效、实用百科Model
 */
@interface LYMaterialDetailData :NSObject
@property (nonatomic , copy) NSString              * effect;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * material_name;
@property (nonatomic , copy) NSString              * create_date;
@property (nonatomic , copy) NSString              * applied;
@property (nonatomic , copy) NSString              * applied_image;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSString              * pick;
@property (nonatomic , copy) NSString              * pick_image;
@property (nonatomic , copy) NSString              * video;
@property (nonatomic , copy) NSString              * effect_image;

@end

@interface LYMaterialDetailModel :NSObject
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , strong) LYMaterialDetailData              * data;
@property (nonatomic , copy) NSString              * timestamp;
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , copy) NSString              * version;

@end

