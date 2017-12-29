//
//  PayCoins.m
//  YiJiaYi
//
//  Created by mac on 2017/2/4.
//  Copyright © 2017年 mac. All rights reserved.

#import "PayCoins.h"
#import "PayGoldCoinsCell.h"
#import "TopUpHeaderView.h"
@interface PayCoins ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) SZRTableView* tableV;
@property (nonatomic,strong) NSMutableArray* dataArr;
@property (nonatomic,strong) TopUpHeaderView* topUpHeaderView;



@end

@implementation PayCoins

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.tableV.rowHeight = 72;
    [self.view addSubview:self.topUpHeaderView];

}
- (void)createUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"充值"}];
//    [SZRFunction SZRSetLayerImage:self.tableV imageStr:SZR_VIEW_BG];
    [self.tableV registerNib:[UINib nibWithNibName:@"PayGoldCoinsCell" bundle:nil] forCellReuseIdentifier:@"PayGoldCoinsCell"];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableV addGestureRecognizer:gestureRecognizer];
    [self createFooterView];
}
- (SZRTableView *)tableV{
    if (_tableV == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight-64) style:UITableViewStylePlain controller:self];
        _tableV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableV.tableFooterView = [UIView new];
    }
    return _tableV;
}
- (TopUpHeaderView *)topUpHeaderView{
    if (!_topUpHeaderView) {
        _topUpHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"TopUpHeaderView" owner:self options:nil] lastObject];
        _topUpHeaderView.frame = CGRectMake(0, 0, SZRScreenWidth, 372);
        _topUpHeaderView.backgroundColor = [UIColor clearColor];
        _tableV.tableHeaderView = _topUpHeaderView;
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        gestureRecognizer.cancelsTouchesInView = NO;
        [_topUpHeaderView addGestureRecognizer:gestureRecognizer];
    }
    return _topUpHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayGoldCoinsCell* payGoldCell = (PayGoldCoinsCell* )[tableView dequeueReusableCellWithIdentifier:@"PayGoldCoinsCell" forIndexPath:indexPath];
   
    return payGoldCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)createFooterView{
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 50)];
        UIButton * quitBtn = [SZRFunction createButtonWithFrame:CGRectMake(50, 10, SZRScreenWidth-100, 35) withTitle:@"充值问题，点此联系客服" withImageStr:nil withBackImageStr:nil];
        [quitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [quitBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:quitBtn];
        self.tableV.tableFooterView = view;
}


-(void)hideKeyboard{
    [self.view endEditing:YES];
}

- (void)payBtnClick:(UIButton* )btn{
    SZRLog(@"充值");
}
- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
