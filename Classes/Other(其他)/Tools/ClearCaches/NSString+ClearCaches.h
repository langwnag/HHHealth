//
//  NSString+ClearCaches.h
//  StoryYourself
//
//  Created by 李晓宁 on 15-12-14.
//  Copyright (c) 2015年 beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ClearCaches)

+(void)clearCaches:(NSString *)path;

+(CGFloat)sizeCaches:(NSString *)path;

@end
