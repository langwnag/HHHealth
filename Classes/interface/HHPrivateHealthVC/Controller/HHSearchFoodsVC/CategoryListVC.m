//
//  CategoryListVC.m
//  YiJiaYi
//
//  Created by mac on 2017/6/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CategoryListVC.h"
#import "HHSearchBar.h"
#import "CategoryListCell.h"
#import "FoodView.h"
#import "PYSearch.h"
@interface CategoryListVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CategorySearchViewDelegate,PYSearchViewControllerDelegate>
@property (nonatomic,strong)UIView *headerView;
/** 搜索 */
@property (nonatomic,strong) HHSearchBar* searchBar;
/** tableView */
@property (nonatomic,strong) SZRTableView* tableV;
@property (nonatomic,strong)UINavigationController *searchNavigationController;

@end

@implementation CategoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataSearch];
    [self configUI];
}
- (HHSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[HHSearchBar alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 44)];
    }
    return _searchBar;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 44)];
    }
    return _headerView;
}


- (void)configUI{
    [self createNavItems:@{NAVTITLE:@"类别列表",NAVLEFTIMAGE:kBackBtnName}];
    [self.tableV registerNib:[UINib nibWithNibName:@"CategoryListCell" bundle:nil] forCellReuseIdentifier:@"CategoryListCell"];
    [self.view addSubview:self.tableV];
    self.searchBar.delegate = self;
    [self.headerView addSubview:self.searchBar];
    self.tableV.tableHeaderView = self.headerView;
}

- (void)loadDataSearch{
    NSDictionary* paramDic = @{@"methodName":@"ApiDishesSearch",
                               @"keyword":@"鱼",
                               @"page":@"1",
                               @"size":@"10",
                               @"appid":COOKING_APPID,
                               @"appkey":COOKING_APPKEY};
    [VDNetRequest COOKING_RequestHandle:paramDic
                         viewController:self
                                success:^(id responseObject) {

                                } failureEndRefresh:^{
                                    
                                } showHUD:NO hudStr:@""];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryListCell* listCell = [tableView dequeueReusableCellWithIdentifier:@"CategoryListCell" forIndexPath:indexPath];

    return listCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 207;
}

- (SZRTableView *)tableV{
    if (!_tableV) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight) style:UITableViewStylePlain controller:self];
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableV.tableFooterView = [UIView new];
    }
    return _tableV;
}



#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    // 1.创建热门搜索
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"输入菜名或食材名搜索" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始搜索执行以下代码
        // 如：跳转到指定控制器
        UIViewController* tempVC = [NSClassFromString(@"TempViewController") new];
        [searchViewController.navigationController pushViewController:tempVC animated:YES];
    }];
    // 3. 设置风格
        searchViewController.hotSearchStyle = PYHotSearchStyleDefault; // 热门搜索风格为默认
        searchViewController.searchHistoryStyle = PYSearchHistoryStyleBorderTag; // 搜索历史风格根据选择
    // 4. 设置代理
    searchViewController.cateDelegate = self;
    searchViewController.delegate = self;
    // 5. 跳转到搜索控制器
    self.searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self.navigationController.view addSubview:self.searchNavigationController.view];


}
- (void)onSearchCancelClick{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchNavigationController.view removeFromSuperview];
        [self.searchNavigationController removeFromParentViewController];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    });

}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) { // 与搜索条件再搜索
        // 根据条件发送查询（这里模拟搜索）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 搜素完毕
            // 显示建议搜索结果
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
                NSString *searchSuggestion = [NSString stringWithFormat:@"搜索建议 %d", i];
                [searchSuggestionsM addObject:searchSuggestion];
            }
            // 返回
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}
- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
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
