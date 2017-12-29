//
//  HtmlModel.h
//  YiJiaYi
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HtmlModel : NSObject
/**
 *  网页标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  网页文件名
 */
@property (nonatomic, copy) NSString *html;

@property (nonatomic, copy) NSString *ID;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)htmlWithDict:(NSDictionary *)dict;

@end
