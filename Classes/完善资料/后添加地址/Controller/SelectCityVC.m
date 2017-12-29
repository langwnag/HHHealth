//
//  SelectCityVC.m
//  Zhuan
//
//  Created by LA on 2017/10/31.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "SelectCityVC.h"
#import "SelectCell.h"
#import "SelectHousingVC.h"
#import "SelectAddressModel.h"
#import "AddressRequest.h"
#import "AddressModel.h"
@interface SelectCityVC ()
/** 市数据源*/
@property (nonatomic, strong) NSMutableArray* cityArray;
/** viewModel*/
@property (nonatomic, strong) AddressRequest* viewModel;
@end

@implementation SelectCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择市";
    [self.tableView registerNib:[UINib nibWithNibName:kSelectCell bundle:nil] forCellReuseIdentifier:kSelectCell];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self loadData];
}
- (void)loadData{
    [MBProgressHUD showMessage:@"正在加载......"];
    @weakify(self)
    //    self.viewModel.pararms = @{@"code":self.areaCodeStr};
    self.viewModel.addressUrlType = 1;
    [[self.viewModel.addressCommand.executionSignals switchToLatest] subscribeNext:^(NSArray* x) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        [self.cityArray addObjectsFromArray:x];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    [self.viewModel.addressCommand execute:@{@"code":self.codeStr}];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectCell forIndexPath:indexPath];
    if (self.cityArray.count) {
        cell.provinceStr = [self.cityArray[indexPath.row] name];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectHousingVC* housingVC = [[SelectHousingVC alloc] init];
    AddressModel* model = self.cityArray[indexPath.row];
    housingVC.areaCodeStr = model.code;
    housingVC.nameStr = [NSString stringWithFormat:@"%@ %@",self.cityStr,model.name];
    [self.navigationController pushViewController:housingVC animated:YES];
}

- (AddressRequest *)viewModel{
    if (!_viewModel) {
        _viewModel = [[AddressRequest alloc] init];
    }
    return _viewModel;
}

- (NSMutableArray *)cityArray{
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}
@end
