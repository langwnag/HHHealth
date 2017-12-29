//
//  PayVC.m
//  YiJiaYi
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PayVC.h"
#import "PayCell.h"
#import "PayHeaderView.h"
#import "PayFooterView.h"
#import "PayMethodModel.h"
#import "DWQPayManager.h"
#import "VisitsManageVC.h"
@interface PayVC ()<UITableViewDelegate,UITableViewDataSource,TableCellDelegate>
/** tableV */
@property (nonatomic,strong) SZRTableView* tableV;
/** payHeaderView */
@property (nonatomic,strong) PayHeaderView* payHeaderView;
/** PayFooterView */
@property (nonatomic,strong) PayFooterView* payFooterView;

/** 支付方式数组 */
@property (nonatomic,strong) NSMutableArray* paymentArr;
/** 当选，当前选中行 */
@property (nonatomic,assign) NSIndexPath* selectedIndexPath;
/** 记录加载次数 */
@property (nonatomic,assign) BOOL isFirstLoad;

@end

@implementation PayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
    [self paymentArr];
}
- (NSMutableArray *)paymentArr{
    if (!_paymentArr) {
        _paymentArr = [NSMutableArray array];
    }
    return _paymentArr;
}
// 查询支付方式
- (void)loadData{
    [VDNetRequest HH_RequestHandle:nil
                               URL:HH_QueryMethodPayment_URL
                    viewController:self
                           success:^(id responseObject) {
//        id obj = responseObject;
        NSArray* dataArr = [PayMethodModel mj_objectArrayWithKeyValuesArray:[RSAAndDESEncrypt DESDecryptResponseObject:responseObject]];
        [self.paymentArr addObjectsFromArray:dataArr];
    
        [self.tableV reloadData];
    } failureEndRefresh:^{
        
    } showHUD:NO hudStr:@""];

}

// 家访订单支付
- (void)loadFamilyVisitPayment{
    PayMethodModel* model = self.paymentArr[_selectedIndexPath.row];
    NSDictionary* paramsDic = @{@"homeServiceId":self.homeServiceId,@"paymentId":model.paymentId};
    [VDNetRequest HH_RequestHandle:paramsDic
                               URL:kURL(@"user/home/addUserServiceHomePay.html")
                    viewController:self
                           success:^(id responseObject) {
//        id obj = responseObject;
        NSDictionary* dataDic = [RSAAndDESEncrypt DESDecryptResponseObject:responseObject];
        SZRLog(@" 😁[RSAAndDESEncrypt DESDecryptResponseObject:responseObject] %@",[RSAAndDESEncrypt DESDecryptResponseObject:responseObject]);

        [self aliPayWithBody:dataDic[@"body"]];
        [self wechatPayment:dataDic];
    } failureEndRefresh:^{
        
    } showHUD:NO hudStr:@""];

}

- (void)wechatPayment:(NSDictionary* )dict{
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"你未安装微信客户端");
    }else if (![WXApi isWXAppSupportApi]){
        NSLog(@"尚不支持微信支付");
    }else{
        [self wechat:dict];
    }
}

- (void)wechat:(NSDictionary* )dict {
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];// 商户ID
    req.prepayId            = [dict objectForKey:@"prepayid"];// 预支付ID
    req.nonceStr            = [dict objectForKey:@"noncestr"];//随机字符串
    req.timeStamp           = [[dict objectForKey:@"timestamp"] intValue];
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    
    [DWQPAYMANAGER dwq_payWithOrderMessage:req callBack:^(DWQErrCode errCode, NSString *errStr) {
        NSLog(@"errCode = %zd,errStr = %@",errCode,errStr);
        if (errCode == DWQErrCodeSuccess) {
            VisitsManageVC* mangerVC = [VisitsManageVC new];
            [self.navigationController pushViewController:mangerVC animated:YES];
            
        }else if (errCode == DWQErrCodeCancel || errCode == DWQErrCodeFailure){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}




- (void)configUI{
    
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"支付"}];

    [self.tableV registerNib:[UINib nibWithNibName:NSStringFromClass([PayCell class]) bundle:nil] forCellReuseIdentifier:@"PayCell"];
    
    self.tableV.rowHeight = kAdaptedHeight_2(100);
    self.tableV.tableHeaderView = self.payHeaderView;
    self.tableV.tableFooterView = self.payFooterView;
    
    self.isFirstLoad = YES;
}
- (SZRTableView *)tableV{
    if (!_tableV) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight- 64) style:UITableViewStylePlain controller:self];
        _tableV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableV.tableFooterView = [UIView new];
    }
    return _tableV;
}

- (PayHeaderView *)payHeaderView{
    if (!_payHeaderView) {
        _payHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"PayHeaderView" owner:self options:nil] lastObject];
        _payHeaderView.frame = CGRectMake(0, 0, 0, kAdaptedHeight_2(100));
    }
    return _payHeaderView;
}

- (PayFooterView *)payFooterView{
    if (!_payFooterView) {
        _payFooterView = [[[NSBundle mainBundle] loadNibNamed:@"PayFooterView" owner:self options:nil] lastObject];
        _payFooterView.backgroundColor = [UIColor clearColor];
        _payFooterView.frame = CGRectMake(0, 0, 0, kAdaptedHeight_2(200));

        [_payFooterView.immediatePaymentPriceBtn setTitle:[NSString stringWithFormat:@"立即支付 ￥%@",self.price] forState:UIControlStateNormal];
        __weak PayVC * weakSelf = self;
        _payFooterView.payBtnClick = ^(){
         
            // 发起支付
            [weakSelf loadFamilyVisitPayment];
        };
    }
    return _payFooterView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paymentArr.count;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayCell* payCell = [tableView dequeueReusableCellWithIdentifier:@"PayCell" forIndexPath:indexPath];
    payCell.delegate = self;
    payCell.selectedIndexPath = indexPath;
    if (self.isFirstLoad && indexPath.row == 0) {
        [payCell.selectBtn setImage:IMG(@"selectStates") forState:UIControlStateNormal];
        self.isFirstLoad = NO;
        _selectedIndexPath = indexPath;
    }
    payCell.payMethodModel = self.paymentArr[indexPath.row];
    return payCell;
}
// 代理方法
- (void)tableCellButtonDidSelected:(NSIndexPath *)selectedIndexPath{
    // 之前选中的，取消选择
    PayCell* payCell = [self.tableV cellForRowAtIndexPath:_selectedIndexPath];
    [payCell.selectBtn setImage:IMG(@"defaultStates") forState:UIControlStateNormal];
    // 记录当前选中的位置索引
    _selectedIndexPath = selectedIndexPath;
    PayCell* payCell1 = [self.tableV cellForRowAtIndexPath:selectedIndexPath];
    [payCell1.selectBtn setImage:IMG(@"selectStates") forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PayCell* payCell = [self.tableV cellForRowAtIndexPath:_selectedIndexPath];
    [payCell.selectBtn setImage:IMG(@"defaultStates") forState:UIControlStateNormal];
    _selectedIndexPath = indexPath;
    PayCell* payCell1 = [self.tableV cellForRowAtIndexPath:indexPath];
    [payCell1.selectBtn setImage:IMG(@"selectStates") forState:UIControlStateNormal];

}


- (void)aliPayWithBody:(NSString *)body{
    /**
     *  @author DevelopmentEngineer-DWQ
     *
     *  来自支付宝文档数据
     */

    NSString* orderMessage = body;
    
    [DWQPAYMANAGER dwq_payWithOrderMessage:orderMessage callBack:^(DWQErrCode errCode, NSString *errStr) {
        NSLog(@"errCode = %zd,errStr = %@",errCode,errStr);
        BOOL payState = errCode == DWQErrCodeSuccess ? YES : NO;
        if (errCode == DWQErrCodeSuccess) {
            VisitsManageVC* mangerVC = [VisitsManageVC new];
            [self.navigationController pushViewController:mangerVC animated:YES];
            
            if (self.passPayStatesBlock) {
                self.passPayStatesBlock(payState);
            }
        }else if (errCode == DWQErrCodeFailure || errCode == DWQErrCodeCancel){
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
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
