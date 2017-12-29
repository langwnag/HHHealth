//
//  HealthCircleModel.h
//  YiJiaYi
//
//  Created by SZR on 2017/5/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureModel.h"
#import "LoginModel.h"

@interface HealthCircleModel : NSObject

@property(nonatomic,strong)NSNumber * commentCount;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,strong)NSNumber * healthyCircleId;
@property(nonatomic,copy)NSString * sendLocation;
@property(nonatomic,strong)NSNumber * sendTime;//时间戳
@property(nonatomic,copy)NSNumber * userId;

@property(nonatomic,strong)NSArray * hhHealthyCirclePicture;

@property(nonatomic,strong)LoginModel * hhuser;

@property(nonatomic,copy)NSArray * likeItemsArray;//点赞数组
@property(nonatomic,copy)NSArray * commentItemsArray;

@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@end
