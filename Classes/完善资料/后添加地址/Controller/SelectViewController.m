//
//  SelectViewController.m
//  Zhuan
//
//  Created by LA on 2017/10/31.
//  Copyright © 2017年 张金山. All rights reserved.
//

#import "SelectViewController.h"
#import "SelectCell.h"
#import "SelectCityVC.h"
#import "AddressModel.h"
#import "AddressRequest.h"
@interface SelectViewController ()
/** 省数据源*/
@property (nonatomic, strong) NSMutableArray* provinceArray;
/** viewModel*/
@property (nonatomic, strong) AddressRequest* viewModel;
@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地区";
  
    [self.tableView registerNib:[UINib nibWithNibName:kSelectCell bundle:nil] forCellReuseIdentifier:kSelectCell];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftBtn:)];
    [self loadData];
}

- (void)loadData{
    [MBProgressHUD showMessage:@"正在加载......"];
    @weakify(self)
    self.viewModel.addressUrlType = 1;
    [[self.viewModel.addressCommand.executionSignals switchToLatest] subscribeNext:^(NSArray* x) {
        @strongify(self)
        [MBProgressHUD hideHUD];
        [self.provinceArray addObjectsFromArray:x];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
    [self.viewModel.addressCommand execute:@{@"code":@"0"}];
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.provinceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectCell forIndexPath:indexPath];
    if (self.provinceArray.count) {
        cell.provinceStr = [self.provinceArray[indexPath.row] name];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectCityVC* cityVC = [[SelectCityVC alloc] init];
    AddressModel* provinceModel = self.provinceArray[indexPath.row];
    cityVC.codeStr = provinceModel.code;
    cityVC.cityStr = provinceModel.name;
    [self.navigationController pushViewController:cityVC animated:YES];
    
}

- (void)leftBtn:(UIBarButtonItem* )item{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

- (AddressRequest *)viewModel{
    if (!_viewModel) {
        _viewModel = [[AddressRequest alloc] init];
    }
    return _viewModel;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
