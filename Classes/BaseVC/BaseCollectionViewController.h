//
//  BaseCollectionViewController.h
//  YiJiaYi
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseVC.h"
#import "AppHubView.h"
@interface BaseCollectionViewController : BaseVC<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,KYEmptyDataSetSource, KYEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *tableViewData;//数据源
@property (nonatomic, assign) NSInteger tablePage;//页数
@property (nonatomic, assign) NSInteger tableLimit;//每页的数量


/**
 *  加载数据，子类需要重写此方法
 *
 *  @param isDropDown 是否下拉表格
 */
- (void)loadNetWorkDataWithIsDropDown:(BOOL)isDropDown;

/**
 *  控制有没有下拉刷新功能
 *
 *  @param haveRefreshHeader yes 有
 */
- (void)setTableViewIsHaveRefreshHeader:(BOOL)haveRefreshHeader;

/**
 *  控制有没有上拉加载功能
 *
 *  @param haveRefreshFooter yes 有
 */
- (void)setTableViewIsHaveRefreshFooter:(BOOL)haveRefreshFooter;

/**
 *  添加数据
 *
 *  @param addData    递增数据
 *  @param totalCount 返回的数据总数量
 */
- (void)addNewData:(NSMutableArray *)addData totalCount:(NSInteger)totalCount;



@end
