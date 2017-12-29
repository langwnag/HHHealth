//
//  LYStoreMainBaseViewController.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import "BaseCollectionViewController.h"
//#import "BaseTableViewController.h"
/**
 列表基类
 */
@interface LYStoreMainBaseViewController : BaseCollectionViewController

- (void)requestNetDataWithReceiveStatus:(NSString *)receiveStatus;

@end
