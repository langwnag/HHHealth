//
//  PracticeVC.h
//  YiJiaYi
//
//  Created by mac on 2017/6/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewControllers.h"
#import "MenuDetailsModel.h"
@interface PracticeVC :BaseTableViewControllers
/** 传入dishesId */
@property (nonatomic,copy) NSString* dishesId;
/** 传入数组step */
@property(nonatomic,copy)NSArray * step;
@end
