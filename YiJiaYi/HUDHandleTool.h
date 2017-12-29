//
//  HUDHandleTool.h
//  BaoXianBaApp
//
//  Created by JngViho on 23/04/2017.
//  Copyright © 2017 yjyc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionAction)(void);

@interface HUDHandleTool : NSObject

void ShowSuccessHUD(NSString *text, UIView *view);
void ShowSuccessHUDcompletion(NSString *text, UIView *view, CompletionAction completionAction);

void ShowErrorHUD(NSString *text, UIView *view);
void ShowErrorHUDcompletion(NSString *text, UIView *view, CompletionAction completionAction);

void ShowLoadingHUD(NSString *text, UIView *view);

void ShowTextHUD(NSString *text, UIView *view);
void ShowTextHUDCompletion(NSString *text, UIView *view, CompletionAction completionAction);

void HideHUD(void);

void HideHUDForView(UIView *view);

@end
