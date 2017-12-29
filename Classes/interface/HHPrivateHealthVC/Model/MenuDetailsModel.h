//
//  MenuDetailsModel.h
//  YiJiaYi
//
//  Created by mac on 2017/7/8.
//  Copyright © 2017年 mac. All rights reserved.
//


#import <Foundation/Foundation.h>



/** 标签 */
@interface Tags_info : NSObject
/** 点赞总数 */
@property(nonatomic,copy)NSString * ID;
/** text */
@property(nonatomic,copy)NSString * text;
/** type */
@property(nonatomic,copy)NSString * type;

@end


/** 做法步骤 */
@interface Step : NSObject
/** 菜谱id */
@property(nonatomic,copy)NSString * dishes_id;
/** 描述 */
@property(nonatomic,copy)NSString * dishes_step_desc;
/** 做法id */
@property(nonatomic,copy)NSString * dishes_step_id;
/** 图片 */
@property(nonatomic,copy)NSString * dishes_step_image;
/** 做法序号 */
@property(nonatomic,copy)NSString * dishes_step_order;

@end



/**
 菜谱详情模型
 */
@interface MenuDetailsModel : NSObject
/** 点赞总数 */
@property(nonatomic,copy)NSString * agreement_amount;
/** <#注释#> */
@property(nonatomic,copy)NSString * click_count;
/** <#注释#> */
@property(nonatomic,copy)NSString * collect_count;
/** 评论总数 */
@property(nonatomic,copy)NSString * comment_count;
/** 烹饪时间 */
@property(nonatomic,copy)NSString * cooking_time;
/** <#注释#> */
@property(nonatomic,copy)NSString * create_date;
/** 菜谱id */
@property(nonatomic,copy)NSString * dishes_id;
/** 菜谱名 */
@property(nonatomic,copy)NSString * dishes_name;
/** 标题 */
@property(nonatomic,copy)NSString * dishes_title;
/** 烹饪难易度 */
@property(nonatomic,copy)NSString * hard_level;
/** 菜谱图片 */
@property(nonatomic,copy)NSString * image;
/** <#注释#> */
@property(nonatomic,copy)NSString * last_update;
/** 描述 */
@property(nonatomic,copy)NSString * material_desc;
/** 准备视频 */
@property(nonatomic,copy)NSString * material_video;
/** 做法视频 */
@property(nonatomic,copy)NSString * process_video;
/** 分享数 */
@property(nonatomic,copy)NSString * share_amount;
/** 口味 */
@property(nonatomic,copy)NSString * taste;

/** 做法步骤 */
@property (nonatomic,strong) NSArray* step;
/** 标签 */ 
@property (nonatomic,strong) NSMutableArray* tags_info;




@end




