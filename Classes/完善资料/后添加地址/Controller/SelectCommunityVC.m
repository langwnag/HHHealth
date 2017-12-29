//
//  SelectCommunityVC.m
//  YiJiaYi
//
//  Created by LA on 2017/11/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SelectCommunityVC.h"
#import "NoCommunityCell.h"
#import "SelectCell.h"
#import "AddressRequest.h"
#import "AddressModel.h"
#import "PerfectInformationVC.h"
@interface SelectCommunityVC ()
/** 区域数据源*/
@property (nonatomic, strong) NSMutableArray* communityArray;
/** viewModel*/
@property (nonatomic, strong) AddressRequest* viewModel;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
@end

@implementation SelectCommunityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择小区";
    [self.tableView registerNib:[UINib nibWithNibName:kSelectCell bundle:nil] forCellReuseIdentifier:kSelectCell];
    [self.tableView registerNib:[UINib nibWithNibName:kNoCommunityCell bundle:nil] forCellReuseIdentifier:kNoCommunityCell];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self loadData];


}

- (void)loadData{
    [MBProgressHUD showMessage:@"正在加载......"];
    @weakify(self)
    self.viewModel.addressUrlType = 2;
    [[self.viewModel.addressCommand.executionSignals switchToLatest] subscribeNext:^(NSArray* x) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        [self.communityArray addObjectsFromArray:x];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    [self.viewModel.addressCommand execute:@{@"code":self.communityCodeStr}];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.communityArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NoCommunityCell* cell =[tableView dequeueReusableCellWithIdentifier:kNoCommunityCell forIndexPath:indexPath];
        return cell;
    }else{
        SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectCell forIndexPath:indexPath];
        cell.provinceStr = [self.communityArray[indexPath.row] communityName];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [NoCommunityCell noCommunityCellHeight];
    }else{
        return [SelectCell cellHeight];
    }
}

//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PerfectInformationVC* perVC = [[PerfectInformationVC alloc] init];
    AddressModel *areaModel = self.communityArray[indexPath.row];
    perVC.addressStr = [NSString stringWithFormat:@"%@ %@",self.addAddressString,areaModel.communityName];
    [[NSUserDefaults standardUserDefaults] setObject:perVC.addressStr forKey:@"address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSKeyAddressName" object:self userInfo:@{@"1":perVC.addressStr}];
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}


- (NSMutableArray *)communityArray{
    if (!_communityArray) {
        _communityArray = [NSMutableArray array];
    }
    return _communityArray;
}

- (AddressRequest *)viewModel{
    if (!_viewModel) {
        _viewModel = [[AddressRequest alloc] init];
    }
    return _viewModel;
}



@end
