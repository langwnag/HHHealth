//
//  SZRNotiTool.h
//  DrugUseTest
//
//  Created by SZR on 2016/12/22.
//  Copyright © 2016年 Family technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DrugUseAlertModel;

@interface SZRNotiTool : NSObject
//添加用药提醒
+(void)scheduleLocalNoti:(DrugUseAlertModel *)model;
//修改用药提醒
+(void)changeLocalNoti:(DrugUseAlertModel *)model;
//移除用药提醒
+(void)removeLocalNoti:(DrugUseAlertModel *)model;




@end
