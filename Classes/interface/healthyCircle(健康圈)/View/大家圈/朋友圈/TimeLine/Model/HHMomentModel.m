//
//  HHMomentModel.m
//  YiJiaYi
//
//  Created by SZR on 2017/6/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHMomentModel.h"

@implementation HHMomentModel

+ (NSDictionary <NSString *, Class> *)whc_ModelReplaceContainerElementClassMapper{
    
    return @{@"data":[HHData class]};
}

@end
@implementation DDPraiseUser

@end
@implementation DDCirclePraiseList
+ (NSDictionary<NSString *,Class> *)whc_ModelReplaceContainerElementClassMapper{
    return @{@"praiseUser":[DDPraiseUser class]};
}

@end
@implementation DDUserIcon

@end
@implementation DDUserInformation


@end
@implementation DDHhuser
+ (NSDictionary<NSString *,Class> *)whc_ModelReplaceContainerElementClassMapper{
    return @{@"userIcon":[DDUserIcon class], @"userInformation":[DDUserInformation class]};
}

@end

@implementation DDUser

@end
@implementation DDCircleCommentList
+ (NSDictionary<NSString *,Class> *)whc_ModelReplaceContainerElementClassMapper{
    return @{ @"user":[DDUser class]};
}
@end
@implementation DDCirclePicture


@end
@implementation HHData

+ (NSDictionary <NSString *, Class> *)whc_ModelReplaceContainerElementClassMapper{
    return @{@"circlePraiseList":[DDCirclePraiseList class], @"circleCommentList":[DDCircleCommentList class], @"hhHealthyCirclePicture":[DDCirclePicture class]};
}


@end

