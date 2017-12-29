//
//  TransactionDetailsVC.m
//  YiJiaYi
//
//  Created by mac on 2017/2/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TransactionDetailsVC.h"
#import "TransactionDetailsView.h"
@interface TransactionDetailsVC ()
@property (nonatomic,strong) TransactionDetailsView* transactionDetailsView;

@end

@implementation TransactionDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"交易明细"}];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.transactionDetailsView];
}
- (TransactionDetailsView *)transactionDetailsView{
    if (!_transactionDetailsView) {
        _transactionDetailsView =[[[NSBundle mainBundle] loadNibNamed:@"TransactionDetailsView" owner:self options:nil] lastObject];
        _transactionDetailsView.frame = CGRectMake(0, 0, SZRScreenWidth, 360);
        }

    return _transactionDetailsView;
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
