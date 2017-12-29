//
//  LYIngredientLayout.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/19.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <UIKit/UIKit.h>

@interface LYIngredientLayout : UICollectionViewFlowLayout

/**
 *  item大小
 */
//@property (nonatomic, assign) CGSize itemSize;
/**
 *  cell与cell之间的距离
 */
@property (nonatomic, assign) CGFloat interitemSpacing;
/**
 *  一行cell与一行cell之间的距离
 */
@property (nonatomic, assign) CGFloat lineSpacing;

@property (nonatomic, assign) UIEdgeInsets contentInset;

@end
