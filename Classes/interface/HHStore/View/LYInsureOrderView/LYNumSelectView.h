//
//  LYNumSelectView.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/5.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <UIKit/UIKit.h>

/**
 数量选择器
 */
@interface LYNumSelectView : UIView

@property (nonatomic, assign) NSInteger currentNum;
@property (nonatomic, assign) NSInteger maxNum;


/**
 初始化

 @param frame frame
 @param currentNum 大于等于1的任意整数
 @param maxNum 大于等于currentNum的任意整数
 @return
 */
- (instancetype)initWithFrame:(CGRect)frame
                   currentNum:(NSInteger)currentNum
                       maxNum:(NSInteger)maxNum;
@end
