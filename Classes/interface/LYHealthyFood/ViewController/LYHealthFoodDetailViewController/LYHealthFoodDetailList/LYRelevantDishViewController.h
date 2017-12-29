//
//  LYRelevantDishViewController.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/11.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <UIKit/UIKit.h>

/**
 食材详情 - 相关菜例
 */
@interface LYRelevantDishViewController : UIViewController

/** tableView */
@property (nonatomic, strong) UITableView * tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataArr;

/** id */
@property (nonatomic, strong) NSString * materialId;
/** page */
@property (nonatomic, assign) NSInteger page;
@end
