//
//  SmallCell.h
//  YiJiaYi
//
//  Created by mac on 2017/6/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
@interface SmallCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView * imageV;
@property(nonatomic,strong)UILabel * label;
@property (nonatomic, strong)  UIImageView *messageImageV;
/** model */
@property (nonatomic,strong) CollectionModel* model;

@end
