//
//  LYRelevantFoodModel.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+WHC_Model.h"

@interface TagsInfo :NSObject
@property (nonatomic , copy) NSString              * tid;
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * type;

@end

@interface LYRelevantDetailData :NSObject
@property (nonatomic , copy) NSString              * desc;
@property (nonatomic , copy) NSString              * video;
@property (nonatomic , copy) NSString              * create_date;
@property (nonatomic , strong) NSArray<TagsInfo *>              * tags_info;
@property (nonatomic , copy) NSString              * cooking_time;
@property (nonatomic , copy) NSString              * hard_level;
@property (nonatomic , copy) NSString              * video1;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * dishes_id;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSString              * taste;
@property (nonatomic , copy) NSString              * play;
@property (nonatomic , copy) NSString              * content;

@end

@interface LYRelevantData :NSObject
@property (nonatomic , copy) NSString              * size;
@property (nonatomic , strong) NSArray<LYRelevantDetailData *>              * data;
@property (nonatomic , copy) NSString              * count;
@property (nonatomic , copy) NSString              * total;
@property (nonatomic , copy) NSString              * page;

@end

@interface LYRelevantFoodModel :NSObject
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , strong) LYRelevantData              * data;
@property (nonatomic , copy) NSString              * timestamp;
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , copy) NSString              * version;

@end

