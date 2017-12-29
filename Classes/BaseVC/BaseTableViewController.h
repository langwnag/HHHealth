//
//  BaseTableViewController.h
//  Doctor
//
//  Created by Mr_Li on 16/3/21.
//  Copyright © 2016年 Mr_Li. All rights reserved.
//

#import "BaseVC.h"
#import "AppHubView.h"

@interface BaseTableViewController : BaseVC<UITableViewDataSource,UITableViewDelegate, KYEmptyDataSetSource, KYEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
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
