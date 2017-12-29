//
//  LYGoodDetailHeadView.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <UIKit/UIKit.h>
#import "LYGoodDetailModel.h"

/**
 商品详情-headView
 */
@interface LYGoodDetailHeadView : UIView
@property (nonatomic, strong) UILabel       * goodNameLab;
@property (nonatomic, strong) UILabel       * goodDescLab;
@property (nonatomic, strong) UILabel       * goodDiscountLab;
@property (nonatomic, strong) UILabel       * goodOriginalLab;
- (void)setDataWithModel:(LYGoodDetailModel *)model;

@end
