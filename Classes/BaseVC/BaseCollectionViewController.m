//
//  BaseCollectionViewController.m
//  YiJiaYi
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseCollectionViewController.h"

@interface BaseCollectionViewController ()
@property (nonatomic, assign) BOOL isDropDown;

@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 8;
    flowLayout.minimumLineSpacing = 8;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44) collectionViewLayout:flowLayout];
//    self.collectionView.frame = self.view.frame;
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //    self.tablePage = 1;
    //    self.tableLimit = 10;
    self.collectionView.emptyDataSetSource = self;
    [self.view addSubview:self.collectionView];
}

#pragma mark - 加载数据
- (void)loadNetWorkDataWithIsDropDown:(BOOL)isDropDown {
    
    self.isDropDown = isDropDown;
    
    if (isDropDown) {
        
        self.tablePage = 1;
        [self.tableViewData removeAllObjects];
        [self.collectionView.mj_footer resetNoMoreData];
        [self.collectionView.mj_header endRefreshing];
    }else {
        
        self.tablePage ++;
    }
}

#pragma mark - 添加数据
- (void)addNewData:(NSMutableArray *)addData totalCount:(NSInteger)totalCount {
    
    if (self.isDropDown) {
        
        [self.collectionView.mj_header endRefreshing];
        
    }else {
        
        [self.collectionView.mj_footer endRefreshing];
    }
    
    if (addData.count == 0 || addData.count == totalCount) {
        
        [self.tableViewData addObjectsFromArray:addData];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        [self.collectionView reloadData];
        if (self.tableViewData.count == 0) {
            self.collectionView.mj_header.hidden = YES;
            self.collectionView.mj_footer.hidden = YES;
        }
        
    }else {
        
        [self.collectionView.mj_header endRefreshing];
        [self.tableViewData addObjectsFromArray:addData];
        [self.collectionView reloadData];
        NSInteger tmpCount = 0;
        if ([addData[0] isKindOfClass:[NSArray class]]) {
            
            for (NSMutableArray * tmpArr in addData) {
                
                tmpCount += tmpArr.count;
            }
        }else{
            
            tmpCount = addData.count;
        }
        
        if (tmpCount < self.tableLimit) {
            
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    //    [self.tableView.mj_footer endRefreshing];
    
    
}

#pragma mark - 刷新加载控件添加功能
- (void)setTableViewIsHaveRefreshHeader:(BOOL)haveRefreshHeader {
    __weak BaseCollectionViewController *weakSelf = self;
    if (haveRefreshHeader) {
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf loadNetWorkDataWithIsDropDown:YES];
        }];
        
    }else {
        
        self.collectionView.mj_header = nil;
    }
}
- (void)setTableViewIsHaveRefreshFooter:(BOOL)haveRefreshFooter {
    
    __weak BaseCollectionViewController *weakSelf = self;
    if (haveRefreshFooter) {
        
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakSelf loadNetWorkDataWithIsDropDown:NO];
        }];
    }else {
        
        self.collectionView.mj_footer = nil;
    }
}
#pragma mark - collectionView DataSource Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
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

#pragma mark - 数据源懒加载
- (NSMutableArray *)tableViewData {
    
    if (!_tableViewData) {
        
        _tableViewData = [[NSMutableArray alloc] init];
    }
    return _tableViewData;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
