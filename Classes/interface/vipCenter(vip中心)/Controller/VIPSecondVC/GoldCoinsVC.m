//
//  GoldCoinsVC.m
//  YiJiaYi
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GoldCoinsVC.h"
#import "ShowStatesCell.h"
#import "PayCoins.h"
#import "TransactionDetailsVC.h"
#import "GoldCoinsHFV.h"
#define TopUpArr @[@"支付宝充值",@"微信充值"]
#define DataArr @[@"2017-02-10 12:23:12",@"2017-02-15 12:34:18"]
#define MoneyArr @[@"50",@"80"]

@interface GoldCoinsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) SZRTableView* tableV;
@property (nonatomic,strong) NSMutableArray* dataArr;

@end

@implementation GoldCoinsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];

}
- (void)createUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"我的合合币"}];
    [self.tableV registerClass:[ShowStatesCell class] forCellReuseIdentifier:@"SHOWSTATESCELL"];
    GoldCoinsHFV * headerView = [[GoldCoinsHFV alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, kAdaptedHeight((380/2)+kAdaptedHeight(45)))];
    __weak typeof(self)weakSelf = self;
    headerView.skipPayBlock = ^(){
        PayCoins* payCoins = [[PayCoins alloc]init];
        [weakSelf.navigationController pushViewController:payCoins animated:NO];
    };
    self.tableV.tableHeaderView = headerView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        for (NSUInteger i = 0; i< 2; ++i) {
            ShowStatesModel* model = [[ShowStatesModel alloc] init];
            model.title = TopUpArr[i];
            model.data = DataArr[i];
            model.money = MoneyArr[i];
            [self.dataArr addObject:model];
        }
        [self.tableV reloadData];
    }
    return _dataArr;
}

- (SZRTableView *)tableV{
    if (_tableV == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain controller:self];
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableV.tableFooterView = [UIView new];
        [_tableV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableV;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return HHIndexRowTwo;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowStatesCell* showCell = (ShowStatesCell* )[tableView dequeueReusableCellWithIdentifier:@"SHOWSTATESCELL" forIndexPath:indexPath];
    showCell.selectionStyle = UITableViewCellSelectionStyleNone;
    ShowStatesModel* model = [self.dataArr objectAtIndex:indexPath.row];
    [showCell configCellWithModel:model];
    
    return showCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowStatesModel* model = [self.dataArr objectAtIndex:indexPath.row];
    return [ShowStatesCell heightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TransactionDetailsVC* trDVC = [TransactionDetailsVC new];
    [self.navigationController pushViewController:trDVC animated:NO];
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
