//
//  BaseTableViewController.h
//  PersonalHomePageDemo
//
//  Created by Kegem Huang on 2017/3/15.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseTableViewControllers;

@protocol BaseTableViewControllerDelegate <NSObject>

-(void)dl_viewControllerDidFinishRefreshing:(BaseTableViewControllers *)viewController;

@end


@interface BaseTableViewControllers : UITableViewController

@property (assign, nonatomic) BOOL canScroll;
@property(nonatomic,assign)BOOL isRefreshing;
@property(nonatomic,weak)id<BaseTableViewControllerDelegate> delegate;

-(void)dl_refresh;

@end
