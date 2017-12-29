//
//  HHModel.h
//  YiJiaYi
//
//  Created by SZR on 2017/5/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserIcon :NSObject
@property (nonatomic , copy) NSString              * pictureUrl;

@end

@interface Hhuser :NSObject
@property (nonatomic , strong) UserIcon              * userIcon;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * userId;

@end

@interface HhHealthyCirclePicture :NSObject
@property (nonatomic , copy) NSString              * userPictureId;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * pictureUrl;

@end

@interface HHModel :NSObject
@property (nonatomic , strong) Hhuser              * hhuser;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * sendLocation;
@property (nonatomic , copy) NSString              * healthyCircleId;
@property (nonatomic , copy) NSString              * sendTime;
@property (nonatomic , strong) NSArray<HhHealthyCirclePicture *>              * hhHealthyCirclePicture;
@property (nonatomic , copy) NSString              * page;
@property (nonatomic , copy) NSString              * commentCount;

@end
