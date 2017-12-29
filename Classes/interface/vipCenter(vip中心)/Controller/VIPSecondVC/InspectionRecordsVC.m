//
//  InspectionRecordsVC.m
//  YiJiaYi
//
//  Created by mac on 2016/12/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "InspectionRecordsVC.h"
#import "InspectionRecordsCell.h"
#import "VisitsManageVC.h"
static NSString * const ID = @"cell";

@interface InspectionRecordsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) SZRTableView* tableV;

@end

@implementation InspectionRecordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)setupUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"我的寻诊记录"}];
    [SZRFunction SZRSetLayerImage:self.tableV imageStr:@""];
    [self.tableV registerNib:[UINib nibWithNibName:@"InspectionRecordsCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.view addSubview:self.tableV];
}

- (SZRTableView *)tableV{
    if (!_tableV) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain controller:self];
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.rowHeight = 92;
        _tableV.tableFooterView = [UIView new];
        [_tableV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableV;
}
#pragma mark dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InspectionRecordsCell* cell = (InspectionRecordsCell* )[tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VisitsManageVC* visitVC = [VisitsManageVC new];
    [self.navigationController pushViewController:visitVC animated:YES];
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
