//
//  ConfirmOrderBottomView.h
//  YiJiaYi
//
//  Created by mac on 2017/7/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderBottomView : UIView
@property (nonatomic,copy) dispatch_block_t commitBtnBlock;
/** 支付价格 */
@property (nonatomic,assign) CGFloat price;


@end
