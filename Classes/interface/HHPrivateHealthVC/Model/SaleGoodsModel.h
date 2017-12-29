//
//  SaleGoodsModel.h
//  YiJiaYi
//
//  Created by mac on 2017/7/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaleGoodsModel : NSObject
/** 图片 */
@property(nonatomic,copy)NSString * attributeUrls;
/** 原价 */
@property (nonatomic , assign) CGFloat              basicPrice;
/** 折扣价 */
@property (nonatomic , assign) CGFloat              discountPrice;
/** 时间 */
@property (nonatomic,assign) long long commodityTime;
/** 商品名 */
@property(nonatomic,copy)NSString * name;
/** 图片 */
@property(nonatomic,copy)NSString * pictureUrl;
/** commodityId */
@property (nonatomic,assign) NSInteger commodityId;
@end
