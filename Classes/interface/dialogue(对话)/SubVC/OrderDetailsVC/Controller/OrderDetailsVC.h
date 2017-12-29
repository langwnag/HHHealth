//
//  OrderDetailsVC.h
//  YiJiaYi
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseVC.h"

@interface OrderDetailsVC : BaseVC
/** 传递价格 */
@property (nonatomic,strong) NSString* price;
/** homeServiceId */
@property (nonatomic,strong) NSString* homeServiceId;

@end
