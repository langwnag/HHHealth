//
//  HtmlModel.m
//  YiJiaYi
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HtmlModel.h"

@implementation HtmlModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.html = dict[@"html"];
        self.title = dict[@"title"];
        self.ID = dict[@"id"];
    }
    return self;
}
+ (instancetype)htmlWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
