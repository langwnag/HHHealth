//
//  LYHealthFoodModel.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/10.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <Foundation/Foundation.h>
#import "NSObject+WHC_Model.h"

@interface LYHealthFoodThridData :NSObject
@property (nonatomic , copy) NSString              * fourId;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSString              * text;

@end

@interface LYHealthFoodSecData :NSObject
@property (nonatomic , copy) NSString              * thirdId;
@property (nonatomic , strong) NSArray<LYHealthFoodThridData *>              * data;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSString              * text;

@end

@interface LYHealthFoodData :NSObject
@property (nonatomic , copy) NSString              * secondId;
@property (nonatomic , strong) NSArray<LYHealthFoodSecData *>              * data;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * text;

@end

@interface LYHealthFoodModel :NSObject
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , strong) LYHealthFoodData              * data;
@property (nonatomic , copy) NSString              * timestamp;
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , copy) NSString              * version;

@end

