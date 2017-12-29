//
//  LYGoodsDetailViewController.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import "BaseTableViewController.h"
/**
 商品详情
 */
@interface LYGoodsDetailViewController : BaseTableViewController

@property (nonatomic, copy) NSString * navTitle;
/** commodity id */
@property (nonatomic, assign) NSInteger commodityId;
/** 是否显示底部按钮 */
@property (nonatomic, assign) BOOL footerState;
@end
