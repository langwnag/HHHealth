//
//  MyAdressVC.m
//  YiJiaYi
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MyAdressVC.h"
#import "SZRTableView.h"
@interface MyAdressVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)SZRTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation MyAdressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"选择地区"}];
    [self initData];
    self.tableView.rowHeight = 44;

}
- (void)initData{
    self.dataArr = [[NSMutableArray alloc] initWithObjects:@"北京市",@"上海市",@"大连市",@"吉林省",@"海南省",@"浙江省",@"河北省", nil];
}

- (SZRTableView *)tableView{
    if (_tableView == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[SZRTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain controller:self];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorColor = SZRSLIDERCOLOR;
        _tableView.tableFooterView = [UIView new];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
        return _tableView;
}
#pragma mark delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"city";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
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
