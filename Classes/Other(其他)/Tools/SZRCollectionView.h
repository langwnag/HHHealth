//
//  SZRCollectionView.h
//  yingke
//
//  Created by SZR on 16/3/21.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZRCollectionView : UICollectionView
/**
 *  初始化collectionView
 *
 *  @param frame      collectionView的大小
 *  @param controller 要添加collectionView的界面
 *
 *  @return collectionView实例
 */
-(instancetype)initWithFrame:(CGRect)frame flowLayOut:(UICollectionViewFlowLayout *)flow controller:(id<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>)controller;

@end
