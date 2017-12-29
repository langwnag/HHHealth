//
//  FixedWidthBtns.h
//  YiJiaYi
//
//  Created by SZR on 2017/2/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const fFontSize;
extern NSString * const fBackgroundColor;
extern NSString * const fBtnFontColor;
extern NSString * const fEachRowBtnNum;
extern NSString * const fBtnWidth;
extern NSString * const fBtnHeight;
extern NSString * const fTopSpace;
extern NSString * const fRowSpace;

typedef void(^BtnViewBlock)(NSInteger);

@interface FixedWidthBtns : UIView

@property(nonatomic,assign)NSInteger fontSize;//字体大小
@property(nonatomic,strong)UIColor * backgroundColor;//btn背景颜色
@property(nonatomic,strong)UIColor * btnFontColor;//btn文字颜色
@property(nonatomic,assign)NSInteger eachRowBtnNum;//每行btn个数
@property(nonatomic,assign)CGFloat btnWidth;
@property(nonatomic,assign)CGFloat btnHeight;
@property(nonatomic,assign)CGFloat topSpace;
@property(nonatomic,assign)CGFloat rowSpace;
@property(nonatomic,copy)BtnViewBlock btnViewBlock;


-(void)loadBtnsWithData:(NSArray *)arr propertyDic:(NSDictionary *)dic;
-(void)loadBtnsWithData:(NSArray *)arr;

@end
