//
//  OrderListCell.h
//  YiJiaYi
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 商品详情cell
 */
@interface OrderListCell : UITableViewCell
/** 商品图片 */
@property (nonatomic,strong) UIImageView* imgUrl;
/** 标题 */
@property(nonatomic,copy)NSString * titleStr;
/** 价格 */
@property(nonatomic,copy)NSString * priceStr;
@end
