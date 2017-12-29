//
//  MenuDetailsModel.m
//  YiJiaYi
//
//  Created by mac on 2017/7/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MenuDetailsModel.h"

@implementation MenuDetailsModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"step":@"Step",
             @"tags_info":@"Tags_info"
             };

}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id"
             };
}
@end
//
//@implementation Step
//
//@end
//
//@implementation Tags_info
//
//@end
//
