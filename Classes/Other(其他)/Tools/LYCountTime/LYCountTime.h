//
//  LYCountTime.h
//  IHealth_V2
//
//  Created by Mr Li on 16/11/9.
//  Copyright © 2016年 zhengmeijie. All rights reserved.

//  Ail Joa Bless me

#import <UIKit/UIKit.h>

#define LY_COUNTTIME [LYCountTime shareCountTime]

/**
 倒计时
 */
@interface LYCountTime : UIView

/**
 单例
 */
+ (LYCountTime *)shareCountTime;


/**
 倒计时

 @param btn 传入需要倒计时的button
 */
- (void)countTimeWithBtn:(UIButton *)btn;

@end
