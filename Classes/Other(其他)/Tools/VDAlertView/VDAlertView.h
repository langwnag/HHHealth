//
//  VDAlertView.h
//  客邦
//
//  Created by SZR on 16/4/8.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <UIKit/UIKit.h>
//提前声明代理
@protocol VDAlertViewDelegate;

@interface VDAlertView : UIView

@property (nonatomic,assign) id<VDAlertViewDelegate>delegate;

/**
 *  初始化自定义的alertView
 *
 *  @param title     view的title
 *  @param delegate  本视图的代理
 *  @param btnTitles 下面btn的title
 *
 *  @return 自定义的alertView
 */
- (instancetype)initWithTitle:(NSString *)title delegate:(id<VDAlertViewDelegate>)delegate btnTitles:(NSArray *)btnTitles;

/**
 *  显示alertView
 */
- (void)show;


@end
@protocol VDAlertViewDelegate <NSObject>

- (void)alertView:(VDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end