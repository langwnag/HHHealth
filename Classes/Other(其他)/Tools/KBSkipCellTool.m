//
//  KBSkipCellTool.m
//  YiJiaYi
//
//  Created by mac on 2016/11/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "KBSkipCellTool.h"
#import "DDMenuController.h"
#import "MedicationToRemindVC.h"
#import "HealthRecordsVC.h"

@implementation KBSkipCellTool

+ (void)chooseSkipCellVC:(NSIndexPath *)indexPath{
    AppDelegate* app = (AppDelegate* )[UIApplication sharedApplication].delegate;
        // 通过window获取ddmenuVC的根视图
    DDMenuController * ddmenuVC = (DDMenuController *)app.window.rootViewController;
    // 显示跟视图
    [ddmenuVC showRootController:YES];
    UINavigationController * nav = (UINavigationController *)[(SZRTabBarVC *)ddmenuVC.rootViewController selectedViewController];
//        UINavigationController * nav = (UINavigationController *).tabBarVC.selectedViewController;
    UIViewController* vc = nil;
    switch (indexPath.row) {
        case 1:
            vc = [[HealthRecordsVC alloc] init];
            
            break;
        case 2:
            vc = [[MedicationToRemindVC alloc] init];
            break;
            
        default:
            break;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:vc animated:YES];
    
}
@end
