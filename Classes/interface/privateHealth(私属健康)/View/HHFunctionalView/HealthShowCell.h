//
//  HealthShowCell.h
//  YiJiaYi
//
//  Created by mac on 2017/6/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleGoodsCell.h"
typedef void (^ClickItemBlock)(NSIndexPath* indexPath);
@interface HealthShowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *saleGoodsLa;
@property (weak, nonatomic) IBOutlet UILabel *moreLa;

@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,copy) NSArray * saleGoodsArr;

@property (nonatomic,copy) ClickItemBlock clickItemBlock;





@end
