//
//  SendServiceOrderVC.h
//  YiJiaYi
//
//  Created by SZR on 2017/3/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseVC.h"

@class DoctListModel;

typedef void(^ComitVisistBlock)(NSString * homeServiceId);

@interface SendServiceOrderVC : BaseVC

@property(nonatomic,strong)DoctListModel * doctorModel;
@property (nonatomic,copy) ComitVisistBlock comitVisistBlock;

@end
