//
//  CompationHeaderView.h
//  YiJiaYi
//
//  Created by mac on 2017/3/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayFooterViews : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *motifyBtn;
//定义一个block
@property (nonatomic,copy) void(^pay)();//付款
@property (nonatomic,copy) void(^cancel)();//取消订单
@property (nonatomic,copy) void(^motify)();//修改



@end
