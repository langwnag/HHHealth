//
//  SaleGoodsCell.h
//  YiJiaYi
//
//  Created by mac on 2017/6/13.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleGoodsModel.h"
@interface SaleGoodsCell : UICollectionViewCell
/** 边框图片 */
@property (nonatomic,strong) UIImageView             *boderImageView;
/** 图片 */
@property (nonatomic,strong) UIImageView             *goodsImageView;
/** 描述 */
@property (nonatomic,strong) UILabel                 *desLa;
/** 优惠价 */
@property (nonatomic,strong) UILabel                 *preferentialPriceLa;
/** 原价 */
@property (nonatomic,strong) UILabel                 *originalPriceLa;
/** model */
@property (nonatomic,strong) SaleGoodsModel* model;


@end
