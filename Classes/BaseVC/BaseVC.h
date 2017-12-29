//
//  BaseVC.h
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const NAVLEFTTITLE;
extern NSString * const NAVLEFTIMAGE;
extern NSString * const NAVRIGTHTITLE;
extern NSString * const NAVRIGHTIMAGE;
extern NSString * const NAVTITLE;


@interface BaseVC : UIViewController

@property(nonatomic,strong)UIButton * leftNavBtn;//左侧导航按钮
@property(nonatomic,strong)UIButton * rightNavBtn;//右侧导航按钮
/** button上文字 */
@property (nonatomic,strong) UILabel* rightText;

/**
 *  初始化数据
 */
-(void)initData;
/**
 *  加载数据
 */
-(void)loadData;
-(void)setNavBarStyle;
/**
 *  创建导航项
 */
-(void)createNavItems:(NSDictionary *)dic;

-(void)resetLeftNavImage:(UIImage *)image;

/**
 *  点击导航栏左边按钮
 */
-(void)leftBtnClick;
/**
 *  点击导航栏右边按钮
 */
-(void)rightBtnClick;


-(void)keyboardNoti;
-(void)removeKeyboardNoti;
-(void)upTextField:(NSNotification *)noti;
-(void)setDownTextField:(NSNotification *)noti;

@end
