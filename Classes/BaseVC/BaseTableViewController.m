//
//  BaseTableViewController.m
//  Doctor
//
//  Created by Mr_Li on 16/3/21.
//  Copyright © 2016年 Mr_Li. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
@property (nonatomic, assign) BOOL isDropDown;
@end


@implementation BaseTableViewController

#pragma mark - 数据源懒加载
- (NSMutableArray *)tableViewData {
    
    if (!_tableViewData) {
        
        _tableViewData = [[NSMutableArray alloc] init];
    }
    return _tableViewData;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = self.view.frame;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tablePage = 1;
//    self.tableLimit = 10;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillLayoutSubviews {
//    __weak HDBaseTableViewController *weakSelf = self;
//    [super viewWillLayoutSubviews];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(weakSelf.view.mas_height).priority(MASLayoutPriorityFittingSizeLevel);
//        make.width.mas_equalTo(weakSelf.view.mas_width).priority(MASLayoutPriorityFittingSizeLevel);
//    }];
//}

//#pragma mark - 初始化
//- (instancetype)init {
//    if (self = [super init]) {
//        
//           }
//    return self;
//}

#pragma mark - 加载数据
- (void)loadNetWorkDataWithIsDropDown:(BOOL)isDropDown {
    
    self.isDropDown = isDropDown;
    
    if (isDropDown) {
        
        self.tablePage = 1;
        [self.tableViewData removeAllObjects];
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_header endRefreshing];
    }else {
        
        self.tablePage ++;
    }
}

#pragma mark - 添加数据
- (void)addNewData:(NSMutableArray *)addData totalCount:(NSInteger)totalCount {
    
    if (self.isDropDown) {
        
        [self.tableView.mj_header endRefreshing];
        
    }else {
        
        [self.tableView.mj_footer endRefreshing];
    }
    
    if (addData.count == 0 || addData.count == totalCount) {
        
        [self.tableViewData addObjectsFromArray:addData];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView reloadData];
        if (self.tableViewData.count == 0) {
                        self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
        }
        
    }else {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableViewData addObjectsFromArray:addData];
        [self.tableView reloadData];
        NSInteger tmpCount = 0;
        if ([addData[0] isKindOfClass:[NSArray class]]) {
            
            for (NSMutableArray * tmpArr in addData) {
                
                tmpCount += tmpArr.count;
            }
        }else{
            
            tmpCount = addData.count;
        }
        
        if (tmpCount < self.tableLimit) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
//    [self.tableView.mj_footer endRefreshing];


}

#pragma mark - 刷新加载控件添加功能
- (void)setTableViewIsHaveRefreshHeader:(BOOL)haveRefreshHeader {
    __weak BaseTableViewController *weakSelf = self;
    if (haveRefreshHeader) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf loadNetWorkDataWithIsDropDown:YES];
        }];
        
    }else {
        
        self.tableView.mj_header = nil;
    }
}
- (void)setTableViewIsHaveRefreshFooter:(BOOL)haveRefreshFooter {
    
    __weak BaseTableViewController *weakSelf = self;
    if (haveRefreshFooter) {
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf loadNetWorkDataWithIsDropDown:NO];
        }];
    }else {
        
        self.tableView.mj_footer = nil;
    }
}
#pragma mark - TableView DataSource Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}
#pragma mark - KYEmptyDataSetSource
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSAttributedString *desString = [[NSAttributedString alloc]initWithString:@"暂无内容"];
    return desString;
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    UIImage *image = [UIImage imageNamed:@"aaa"];
    return image;
}
@end
