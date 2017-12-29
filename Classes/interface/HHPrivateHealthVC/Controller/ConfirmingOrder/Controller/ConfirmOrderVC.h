//
//  ConfirmOrderVC.h
//  YiJiaYi
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseVC.h"

typedef NS_ENUM(NSInteger, HHConfirmOrderCellStyle) {
    HHConfirmOrderListCellTag = 0,// 商品缩略图(0)
    HHConfirmOrderNumCellTag ,// 数量cell(1)
    HHConfirmCouponsCellTag ,// 优惠券(2)
    HHConfirmAmountGoodsCellTag // 商品金额(3)
};
@interface ConfirmOrderVC : BaseVC

@property (nonatomic,assign)HHConfirmOrderCellStyle cellType;
/** 图片 */
@property(nonatomic,copy)NSString * goodsImgUrl;
/** 商品名称 */
@property(nonatomic,copy)NSString * goodsName;
/** 商品价格 */
@property (nonatomic,assign) CGFloat commodityPrice;

@end
