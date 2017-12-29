//
//  SZRImageBrower.h
//  yingke
//
//  Created by SZR on 16/3/28.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ShowNavBarBlock)(void);




@interface SZRImageBrower : NSObject<UIScrollViewDelegate>

@property(nonatomic,copy)ShowNavBarBlock showNavBarBlock;

@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)UIView * view;

/**
 *  浏览图片
 *
 *  @param imageView 图片所在的imageView
 */
+ (instancetype)sharedInstance;

+(void)createUI:(UIImageView *)SZRimageView view:(UIView *)view;


@end
