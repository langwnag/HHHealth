
//
//  Tool.m
//  UI12_cell自适应
//
//  Created by lanou on 16/1/28.
//  Copyright © 2016年 denfun. All rights reserved.
//

#import "Tool.h"

@implementation Tool

//计算图片高度;
-(CGFloat)getImageHeight:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    CGFloat W = image.size.width;
    CGFloat H = image.size.height;
    
    return (kSCREEN_WIDTH*H)/W;
}


//计算文字高度;
-(CGFloat)getLabelHeight:(NSString *)content font:(UIFont *)font
{
    
    CGSize size =  CGSizeMake(kSCREEN_WIDTH, 100000);
    NSDictionary *dic = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    CGRect rect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}







@end
