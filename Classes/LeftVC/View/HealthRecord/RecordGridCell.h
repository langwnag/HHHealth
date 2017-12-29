//
//  RecordGridCell.h
//  YiJiaYi
//
//  Created by mac on 2016/12/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ImageClickBlock)(NSIndexPath* );

@interface RecordGridCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView * collectionView;

/**
 顶部线
 */
@property (nonatomic,strong) UIView* topView;
@property(nonatomic,strong)NSArray * dataArr;
-(void)loadDataWithArr:(NSArray *)arr;

@property(nonatomic,copy)ImageClickBlock imageClickBlock;

@end
