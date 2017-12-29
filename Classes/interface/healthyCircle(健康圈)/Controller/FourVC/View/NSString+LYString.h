//
//  NSStirng+LYString.h
//  LYMoment
//
//  Created by Mr_Li on 2017/5/18.
//  Copyright © 2017年 Mr_Li. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface NSString (LYString)

/**
 *  获取字符串高度
 */
+ (CGFloat)getHeightWithString:(NSString *)str width:(CGFloat)width font:(CGFloat)font;
/**
 *  获取字符串宽度
 */
+ (CGFloat)getWidthWithString:(NSString *)str height:(CGFloat)height font:(CGFloat)font;
/**
    根据时间戳获取时间
 */
+ (NSString *)getTimeWithStamp:(NSString *)timeStamp dateFormartter:(NSString *)dateFormatter;
/**
    获取attStr
 */
+ (NSMutableAttributedString *)getAttStrWithStr:(NSString *)str withRange:(NSRange)range;
@end
