//
//  Tool.h
//  UI12_cell自适应
//
//  Created by lanou on 16/1/28.
//  Copyright © 2016年 denfun. All rights reserved.
//
/**
 * 屏幕的宽度
 */
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

/**
 * 屏幕高度
 */
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tool : NSObject

//计算图片高度的方法;
-(CGFloat)getImageHeight:(NSString *)name;

//计算label高度的方法;(需要告诉显示的字和font)
-(CGFloat)getLabelHeight:(NSString *)content font:(UIFont *)font;







@end
