//
//  BigItem.h
//  YiJiaYi
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
@interface BigItem : UICollectionViewCell
@property (nonatomic, strong)  UIImageView *headerImage;
@property (nonatomic, strong)  UIImageView *messageImageV;
/** 健康师名字 */
@property(nonatomic,copy)NSString * nameStr;
/** 签约数 */
@property(nonatomic,copy)NSString * numStr;

/** model */
@property (nonatomic,strong) CollectionModel* model;

@end
