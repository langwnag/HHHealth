//
//  HUDHandleTool.m
//  BaoXianBaApp
//
//  Created by JngViho on 23/04/2017.
//  Copyright © 2017 yjyc. All rights reserved.
//

#import "HUDHandleTool.h"
#import <MBProgressHUD.h>
//HUD默认添加位置
#define JudgeView(VIEW) (VIEW) ? (VIEW) : [[UIApplication sharedApplication] keyWindow]
//HUD与控件的间隙
#define Margin 15
//HUD偏移
#define Offset CGPointMake(0, -30)
//显示时间
#define ShowTime 1.5

@implementation HUDHandleTool

void ShowSuccessHUD(NSString *text, UIView * view) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:JudgeView(view) animated:true];
        hud.mode = MBProgressHUDModeCustomView;
        [hud setMargin:Margin];
        [hud setOffset:Offset];

        NSString *rescourePath = [[NSBundle mainBundle] pathForResource:@"HUD" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:rescourePath];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark_white" inBundle:bundle compatibleWithTraitCollection:nil]];
        
        hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
        
        hud.minSize = CGSizeMake(115, 100);
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:ShowTime];
    });
}

void ShowSuccessHUDcompletion(NSString *text, UIView *view, CompletionAction completionAction) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:JudgeView(view) animated:true];
        hud.mode = MBProgressHUDModeCustomView;
        [hud setMargin:Margin];
        [hud setOffset:Offset];
        
        NSString *rescourePath = [[NSBundle mainBundle] pathForResource:@"HUD" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:rescourePath];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark_white" inBundle:bundle compatibleWithTraitCollection:nil]];;
        
        hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
        
        hud.minSize = CGSizeMake(115, 100);
        hud.removeFromSuperViewOnHide = YES;
        
        hud.completionBlock = completionAction;
        [hud hideAnimated:YES afterDelay:ShowTime];
    });
}

void ShowErrorHUD(NSString *text, UIView *view) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:JudgeView(view) animated:true];
        hud.mode = MBProgressHUDModeCustomView;
        [hud setMargin:Margin];
        [hud setOffset:Offset];
        
        NSString *rescourePath = [[NSBundle mainBundle] pathForResource:@"HUD" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:rescourePath];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close" inBundle:bundle compatibleWithTraitCollection:nil]];
        
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
        
        hud.minSize = CGSizeMake(115, 100);
        hud.removeFromSuperViewOnHide = YES;
        
        hud.completionBlock = ^{
            NSLog(@"消失之后的动作");
        };
        [hud hideAnimated:YES afterDelay:ShowTime];
    });
}

void ShowErrorHUDcompletion(NSString *text, UIView *view, CompletionAction completionAction) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:JudgeView(view) animated:true];
        hud.mode = MBProgressHUDModeCustomView;
        [hud setMargin:Margin];
        [hud setOffset:Offset];
        
        NSString *rescourePath = [[NSBundle mainBundle] pathForResource:@"HUD" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:rescourePath];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close" inBundle:bundle compatibleWithTraitCollection:nil]];
        hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
        
        hud.minSize = CGSizeMake(115, 100);
        hud.removeFromSuperViewOnHide = YES;
        
        
        hud.completionBlock = completionAction;
        [hud hideAnimated:YES afterDelay:ShowTime];
    });
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
void ShowLoadingHUD(NSString *text, UIView *view) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:JudgeView(view) animated:true];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.minSize = CGSizeMake(100, 100);
        hud.square = YES;
        hud.userInteractionEnabled = NO;
        hud.removeFromSuperViewOnHide = YES;
        hud.activityIndicatorColor = [UIColor whiteColor];
        [hud setOffset:CGPointMake(0, -20)];

        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
        // YES代表需要蒙版效果
        hud.dimBackground = NO;
    });
}
#pragma clang diagnostic pop
void ShowTextHUD(NSString *text, UIView *view) {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:JudgeView(view) animated:true];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.font = [UIFont systemFontOfSize:17];
        hud.detailsLabel.text = text;
        hud.detailsLabel.textColor = [UIColor whiteColor];;
        hud.removeFromSuperViewOnHide = YES;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [hud hideAnimated:YES afterDelay:1.5];
    });
}

void ShowTextHUDCompletion(NSString *text, UIView *view, CompletionAction completionAction) {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:JudgeView(view) animated:true];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
        hud.removeFromSuperViewOnHide = YES;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        hud.completionBlock = completionAction;
        [hud hideAnimated:YES afterDelay:1.5];
    });
}

void HideHUD() {
    HideHUDForView(nil);
}
void HideHUDForView(UIView *view) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:JudgeView(view) animated:YES];
    });
}
@end
