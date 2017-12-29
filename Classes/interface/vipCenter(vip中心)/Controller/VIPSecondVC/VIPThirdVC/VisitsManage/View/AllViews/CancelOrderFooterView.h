//
//  CancelOrderFooterView.h
//  YiJiaYi
//
//  Created by mac on 2017/3/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectFamilyVisitModel;
@interface CancelOrderFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *statesBtn;
@property (nonatomic,copy) void(^cancelBlock)();//取消订单
@property (nonatomic,copy) void(^completeBlock)();//已完成
@property (nonatomic,copy) void(^evaluationBlock)();//评价
/** model */
@property (nonatomic,strong) SelectFamilyVisitModel* selectFamilyVisitModel;

@end
