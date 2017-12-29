//
//  HHMomentModel.h
//  YiJiaYi
//
//  Created by SZR on 2017/6/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+WHC_Model.h"

@interface DDPraiseUser :NSObject
@property (nonatomic , copy) NSString              * nickname;

@end

@interface DDCirclePraiseList :NSObject
@property (nonatomic , assign) NSInteger              praiseTime;
@property (nonatomic , assign) NSInteger              healthyCircleId;
@property (nonatomic , strong) DDPraiseUser              * praiseUser;
@property (nonatomic , assign) NSInteger              praiseId;
@property (nonatomic , assign) NSInteger              userId;

@end

@interface DDUserIcon :NSObject
@property (nonatomic , copy) NSString              * pictureUrl;

@end

@interface DDUserInformation :NSObject
@property (nonatomic , assign) NSInteger              age;
@property (nonatomic , copy) NSString              * position;
@end

@interface DDHhuser :NSObject
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , strong) DDUserIcon              * userIcon;
@property (nonatomic , strong) DDUserInformation              * userInformation;
@end

@interface DDUser :NSObject
@property (nonatomic , copy) NSString              * nickname;
@end

@interface DDCircleCommentList :NSObject
@property (nonatomic , assign) NSInteger              parentId;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , assign) NSInteger              commentTime;
@property (nonatomic , assign) NSInteger              parentUserId;
@property (nonatomic , copy) NSString              * parentUserNickname;
@property (nonatomic , copy) NSString              * commentContent;
@property (nonatomic , assign) NSInteger              commentId;
@property (nonatomic , strong) DDUser              * user;
@end

@interface DDCirclePicture :NSObject
@property (nonatomic , copy) NSString              * pictureUrl;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              userPictureId;
@end

@interface HHData :NSObject
@property (nonatomic , strong) NSMutableArray<DDCirclePraiseList *>              * circlePraiseList;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , strong) DDHhuser              * hhuser;
@property (nonatomic , copy) NSString              * sendLocation;
@property (nonatomic , strong) NSMutableArray<DDCircleCommentList *>              * circleCommentList;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , assign) NSInteger              healthyCircleId;
@property (nonatomic , assign) NSInteger              sendTime;
@property (nonatomic , strong) NSArray<DDCirclePicture *>              * hhHealthyCirclePicture;
@property (nonatomic , assign) NSInteger              page;
@property (nonatomic , assign) NSInteger              commentCount;

@end
@interface HHMomentModel :NSObject
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , strong) NSArray<HHData *>              * data;
@property (nonatomic , copy) NSString              * message;
@property (nonatomic , assign) BOOL              result;

@end
