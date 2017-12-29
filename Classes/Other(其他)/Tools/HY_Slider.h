//
//  HY_Slider.h
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/16.
//  Copyright © 2016年 mac. All rights reserved.
//
typedef void(^valueChangeBlock)(int index);

#import <UIKit/UIKit.h>

@interface HY_Slider : UIControl
/**
 *  回调
 */
@property (nonatomic,copy)valueChangeBlock block;

/**
 *  初始化方法
 *
 *  @param frame
 *  @param titleArray         必传，传入节点数组
 *  @param firstAndLastTitles 首，末位置的title
 *  @param defaultIndex       必传，范围（0到(array.count-1)）
 *  @param sliderImage        传入画块图片
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame
                      titles:(NSArray *)titleArray
          firstAndLastTitles:(NSArray *)firstAndLastTitles
                defaultIndex:(CGFloat)defaultIndex
                 sliderImage:(UIImage *)sliderImage;


@end
