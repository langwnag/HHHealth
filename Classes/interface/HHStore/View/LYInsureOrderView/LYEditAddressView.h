//
//  LYEditAddressView.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/5.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <UIKit/UIKit.h>

@protocol LYEditAddressViewDelegate <NSObject>

- (void)clickAddressView:(UILabel *)lab;

@end
/**
 确认订单 - 编辑地址View
 */
@interface LYEditAddressView : UIView

@property (nonatomic, weak) id<LYEditAddressViewDelegate>delegate;

@end
