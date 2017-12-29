
//
//  SelectHousingVC.m
//  Zhuan
//
//  Created by LA on 2017/10/31.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "SelectHousingVC.h"
#import "SelectCell.h"
#import "SelectAddressModel.h"
#import "AddressRequest.h"
#import "AddressModel.h"
#import "SelectCommunityVC.h"

@interface SelectHousingVC ()
/** 区域数据源*/
@property (nonatomic, strong) NSMutableArray* areaArray;
/** viewModel*/
@property (nonatomic, strong) AddressRequest* viewModel;
@end

@implementation SelectHousingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地区";
    [self.tableView registerNib:[UINib nibWithNibName:kSelectCell bundle:nil] forCellReuseIdentifier:kSelectCell];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self loadData];
}

- (void)loadData{
    [MBProgressHUD showMessage:@"正在加载......"];
    @weakify(self)
    self.viewModel.addressUrlType = 1;
    [[self.viewModel.addressCommand.executionSignals switchToLatest] subscribeNext:^(NSArray* x) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        [self.areaArray addObjectsFromArray:x];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    [self.viewModel.addressCommand execute:@{@"code":self.areaCodeStr}];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.areaArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectCell forIndexPath:indexPath];
    
    AddressModel * areaModel = self.areaArray[indexPath.row];
    cell.provinceStr = areaModel.name;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SelectCell cellHeight];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SelectCommunityVC* communityVC = [[SelectCommunityVC alloc] init];
    AddressModel * areaModel = self.areaArray[indexPath.row];
    communityVC.communityCodeStr =  areaModel.code;
    communityVC.addAddressString = [NSString stringWithFormat:@"%@ %@",self.nameStr,areaModel.name];;
    [self.navigationController pushViewController:communityVC animated:YES];
    
}

- (NSMutableArray *)areaArray{
    if (!_areaArray) {
        _areaArray = [NSMutableArray array];
    }
    return _areaArray;
}

- (AddressRequest *)viewModel{
    if (!_viewModel) {
        _viewModel = [[AddressRequest alloc] init];
    }
    return _viewModel;
}

@end
