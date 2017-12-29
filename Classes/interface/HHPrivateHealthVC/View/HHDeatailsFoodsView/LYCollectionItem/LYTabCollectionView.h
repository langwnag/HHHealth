//
//  LYTabCollectionView.h
//  HUGHIOIJOGERJIOGRE
//
//  Created by Mr.Li on 2017/6/30.
//  Copyright © 2017年 Mr.Li. All rights reserved.

//  YH.X Bless me

#import <UIKit/UIKit.h>

typedef void(^LYSelectTabBlock)(NSString * title);

@interface LYTabCollectionView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
//数据源
@property (nonatomic, strong) NSArray               * dataArr;
//点击标签回调
@property (nonatomic, copy) LYSelectTabBlock selectTabBlock;
//设置是否有选择效果（默认为NO）
@property (nonatomic, assign) BOOL selectEffect;

@end
