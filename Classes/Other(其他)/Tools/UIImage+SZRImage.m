//
//  UIImage+SZRImage.m
//  yingke
//
//  Created by SZR on 16/3/14.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "UIImage+SZRImage.h"

@implementation UIImage (SZRImage)

//设置Image大小
-(UIImage *)SZRScaleToSize:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = [UIGraphicsGetImageFromCurrentImageContext() imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;

}

@end
