//
//  MBProgressHUD+NJ.h
//  NJWisdomCard
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (NJ)


+ (void)showSuccess:(NSString *)success;
/**
 *  若ret = YES 在现实之前要隐藏其他的 progressHUD
 */
+ (void)showSuccess:(NSString *)success hideBeforeShow:(BOOL)ret;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;

+ (void)showError:(NSString *)error hideBeforeShow:(BOOL)ret;

+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;

+ (void)hideHUDForView:(UIView *)view;

//只有文字
+ (void)showTextOnly:(NSString *)text;
+ (void)showTextOnly:(NSString *)text hideBeforeShow:(BOOL)ret;



@end
