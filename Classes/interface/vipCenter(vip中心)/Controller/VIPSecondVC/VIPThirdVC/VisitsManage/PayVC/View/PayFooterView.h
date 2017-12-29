//
//  PayFooterView.h
//  YiJiaYi
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *immediatePaymentPriceBtn;
@property (nonatomic,strong) dispatch_block_t payBtnClick;
@end
