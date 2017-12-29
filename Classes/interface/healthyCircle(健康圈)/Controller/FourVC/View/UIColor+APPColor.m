//
//  UIColor+APPColor.m
//  IHealth_V2
//
//  Created by Mr_Li on 16/12/3.
//  Copyright © 2016年 Mr_Li. All rights reserved.
//

#import "UIColor+APPColor.h"

@implementation UIColor (APPColor)

+ (UIColor *)getRGBColor:(unsigned long)rgbValue{

    return [self getRGBColor:rgbValue alpha:1];
}

+ (UIColor *)getRGBColor:(unsigned long)rgbValue alpha:(float)alpha{

    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:alpha];

}


+ (UIColor *)mainColor{

    return [self getRGBColor:0X077D4D];
}

+ (UIColor *)tabBarColor{

    return [self getRGBColor:0XF3F2F2];
}

+(UIColor *)backgroundColor{

    return [self getRGBColor:0xECECEC];
}

+(UIColor *)lightBorderColor{
    
    return [self getRGBColor:0xECECEC];
}

+ (UIColor *)darkBorderColor{

    return [self getRGBColor:0xc9c9c9];
}

+ (UIColor *)black{

    return [self getRGBColor:0x333333];
}

+ (UIColor *)red{

    return [self getRGBColor:0xff7372];
}

+ (UIColor *)lightGray{

    return [self getRGBColor:0x808080];
}

@end
