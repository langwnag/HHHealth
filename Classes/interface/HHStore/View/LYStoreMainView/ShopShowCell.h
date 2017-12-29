//
//  ShopShowCell.h
//  YiJiaYi
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYStoreMainDetail;
UIKIT_EXTERN NSString * const kShopShowCell;
@interface ShopShowCell : UICollectionViewCell
/** 传递模型数据 */
@property (nonatomic,strong)LYStoreMainDetail* goodModel;

@end
