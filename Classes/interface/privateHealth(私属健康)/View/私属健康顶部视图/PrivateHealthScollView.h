//
//  PrivateHealthScollView.h
//  YiJiaYi
//
//  Created by SZR on 16/9/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateHealthScollView : UIView


//-(instancetype)initWithFrame:(CGRect)frame headImage:(NSString *)headImageStr healthValue:(CGFloat)healthValue vipLevel:(NSInteger)vipLevel;
-(instancetype)initWithFrame:(CGRect)frame headImage:(NSString *)headImageStr healthValue:(CGFloat)healthValue vipLevel:(NSInteger)vipLevel healthStr:(NSString *)healthStr healthValueStr:(int)healthValueStr dateStr:(NSString *)dateStr;
-(void)updateHeadImage:(NSString *)imageURL vipLevel:(int)vipLevel;

@end
