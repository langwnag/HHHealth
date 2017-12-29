//
//  ServiceOrderView.h
//  YiJiaYi
//
//  Created by SZR on 2017/3/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceOrderModel;
@interface ServiceOrderView : UIView

@property(nonatomic,strong)ServiceOrderModel * serviceOrderModel;

-(void)loadData;

@end
