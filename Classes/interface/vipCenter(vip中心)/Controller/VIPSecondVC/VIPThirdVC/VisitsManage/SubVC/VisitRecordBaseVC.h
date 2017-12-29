//
//  VisitRecordBaseVC.h
//  YiJiaYi
//
//  Created by mac on 2017/5/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseTableViewController.h"
/**
 全部、未服务、已完成基类
 */
@interface VisitRecordBaseVC : BaseTableViewController
- (void)requestNetDataWithReceiveStatus:(NSString *)receiveStatus;

@end
