//
//  LYFoodDetailViewController.h
//  LYScrollView
//
//  Created by Mr.Li on 2017/6/28.
//  Copyright © 2017年 Mr.Li. All rights reserved.

//  YH.X Bless me

//#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "LYRelevantDishViewController.h"

@interface LYFoodDetailViewController : BaseVC

/** 食材id */
@property (nonatomic, strong) NSString * materialId;
/** imageUrl */
@property (nonatomic, strong) NSString * imageStr;
/** 导航栏标题 */
@property (nonatomic, strong) NSString * navTitle;
/** video str */
@property (nonatomic, strong) NSString * urlStr;

@end
