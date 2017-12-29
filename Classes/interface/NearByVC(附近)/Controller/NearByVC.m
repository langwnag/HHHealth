//
//  NearByVC.m
//  YiJiaYi
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NearByVC.h"
#import "LYStoreMainCell.h"
#import "NearByRequest.h"
#import "LYStoreMainListModel.h"
#import "LYGoodsDetailViewController.h"

@interface NearByVC ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic,strong) SZRTableView* tableView;
/** dataArray */
@property (nonatomic,strong) NSMutableArray* dataArray;
@property (nonatomic,strong) NearByRequest* viewModel;
@property (nonatomic,assign) NSInteger tablePage;
@end

@implementation NearByVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.viewModel.tablePage = 0;

    [self createUpRefresh];
    [self createDownrefresh];
    [self loadData];

}

- (void)loadData{
    self.viewModel.tablePage ++;

    [MBProgressHUD showMessage:@"正在加载......"];
    @weakify(self)
    [[self.viewModel.nearByCommand execute:nil] subscribeNext:^(NSArray* x) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        if ([x count] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.dataArray addObjectsFromArray:x];
            [self.tableView reloadData];
            [self endRefresh];
        }

    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self endRefresh];
    }];

}

// up
- (void)createUpRefresh{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        self.viewModel.tablePage ++;

        [self loadData];
    }];
}
// down
- (void)createDownrefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        self.viewModel.tablePage = 1;
        [self loadData];
        [self endRefresh];
    }];
}

- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYStoreMainCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LYStoreMainCell" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        LYStoreMainDetail * model = self.dataArray[indexPath.row];
        [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.attributeUrl] placeholderImage:[UIImage imageNamed:@"goodsDefaultImage"]];
        cell.commodityName = model.name;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 194;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LYGoodsDetailViewController * vc = [[LYGoodsDetailViewController alloc] init];
    LYStoreMainDetail * model = self.dataArray[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    vc.commodityId = model.commodityId;
    vc.navTitle = model.name;
    vc.footerState = YES;
    [self.navigationController pushViewController:vc animated:YES];

}


- (SZRTableView *)tableView{
    if (!_tableView) {
        _tableView = [[SZRTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain controller:self];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerNib:[UINib nibWithNibName:@"LYStoreMainCell" bundle:nil] forCellReuseIdentifier:@"LYStoreMainCell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NearByRequest *)viewModel{
    if (!_viewModel) {
        _viewModel = [[NearByRequest alloc] init];
    }
    return _viewModel;
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
