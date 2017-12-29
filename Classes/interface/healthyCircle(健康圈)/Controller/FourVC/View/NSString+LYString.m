//
//  NSStirng+LYString.m
//  LYMoment
//
//  Created by Mr_Li on 2017/5/18.
//  Copyright © 2017年 Mr_Li. All rights reserved.
//

#import "NSString+LYString.h"
#import "UIColor+APPColor.h"

@implementation NSString (LYString)

#pragma mark - 获取字符串高度
+ (CGFloat)getHeightWithString:(NSString *)str width:(CGFloat)width font:(CGFloat)font{
    
    if (str.length == 0)
        return 0;
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 0)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                    context:nil].size;
    
    return size.height + 1;
}

#pragma mark - 获取字符串宽度
+ (CGFloat)getWidthWithString:(NSString *)str height:(CGFloat)height font:(CGFloat)font{
    
    if (!str)
        return 0;
    CGSize size = [str boundingRectWithSize:CGSizeMake(height, 0)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                    context:nil].size;
    return size.height;
}
#pragma mark - 根据时间戳获取时间
+ (NSString *)getTimeWithStamp:(NSString *)timeStamp dateFormartter:(NSString *)dateFormatter{
    NSInteger date = [timeStamp integerValue] / 1000;
    NSDate * chatDate = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:dateFormatter];
    NSString * timeStr = [dateFormater stringFromDate:chatDate];
    return timeStr;
}
#pragma mark - 获取attStr
+ (NSMutableAttributedString *)getAttStrWithStr:(NSString *)str withRange:(NSRange)range{
    
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor getRGBColor:0x05cfaa] range:range];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
    return attStr;
}
@end
