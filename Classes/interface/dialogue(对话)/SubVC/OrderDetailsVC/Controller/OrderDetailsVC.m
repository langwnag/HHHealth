//
//  OrderDetailsVC.m
//  YiJiaYi
//
//  Created by mac on 2017/6/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "OrderLabelAndTFCell.h"
#import "NamePhoneNumCell.h"
#import "OtherNeedFooterView.h"
#import "OrderAddressCell.h"
#import "ServiceTimesCell.h"
#import "ServiceOrderModel.h"
#import "ServiceAmountView.h"
#import "NSDate+Extension.h"
#import "PayVC.h"
#import "OrderDetailsModel.h"
@interface OrderDetailsVC ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>
@property(nonatomic,strong)SZRTableView * tableView;

@property (nonatomic, strong)ServiceAmountView* footerView;
/** model */
@property (nonatomic,strong) OrderDetailsModel* selectModel;


@end

@implementation OrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataOrderDetails];
    [self configUI];
}

-(void)configUI{
    
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"服务订单详细"}];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.estimatedRowHeight = k6P_3AdaptedHeight(136);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderLabelAndTFCell" bundle:nil] forCellReuseIdentifier:@"OrderLabelAndTFCell"];
    [self.tableView registerClass:[OrderAddressCell class] forCellReuseIdentifier:@"OrderAddressCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NamePhoneNumCell" bundle:nil] forCellReuseIdentifier:@"NamePhoneNumCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ServiceTimesCell" bundle:nil] forCellReuseIdentifier:@"ServiceTimesCell"];
    
    
    self.footerView = [[NSBundle mainBundle] loadNibNamed:@"ServiceAmountView" owner:self options:nil][0];
    self.footerView.frame = CGRectMake(0, 0, SZRScreenWidth, k6P_3AdaptedHeight(600));
    self.footerView.priceTF.delegate = self;
    
    __weak OrderDetailsVC * weakSelf = self;
    self.footerView.serviceBtnBlock = ^(CGFloat price){
        
        if (_selectModel.serviceFee == 0.00) {
            [weakSelf loadDataSingleFree:weakSelf.homeServiceId];
        }else{
            if ([weakSelf.selectModel.serviceOrderState isEqualToString:@"PAY_COMPLETE"]) {
                [MBProgressHUD showTextOnly:@"该订单已支付"];
                return ;
            }
            PayVC* payVC = [PayVC new];
            payVC.price = [NSString stringWithFormat:@"%.2f",weakSelf.selectModel.serviceFee];
            payVC.homeServiceId = [NSString stringWithFormat:@"%ld",(long)weakSelf.selectModel.homeServiceId];
            [weakSelf.navigationController pushViewController:payVC animated:YES];
        }
    };
    self.footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = self.footerView;

}

/**
 用户查看订单详细
 */
- (void)loadDataOrderDetails{
    NSDictionary* paramsDic = @{@"homeServiceId":self.homeServiceId};
    [VDNetRequest HH_RequestHandle:paramsDic
                               URL:kURL(@"user/home/selectUserServiceHomeById.html") viewController:self
                           success:^(id responseObject) {
                               [MBProgressHUD hideHUD];

                               id obj = [RSAAndDESEncrypt DESDecryptResponseObject:responseObject];
                               _selectModel = [OrderDetailsModel mj_objectWithKeyValues:obj];
                               
                               self.footerView.pricesPromptLa.text = [NSString stringWithFormat:@"%.2f",_selectModel.serviceFee];

                               [self.tableView reloadData];
                           } failureEndRefresh:^{
                               
                           } showHUD:YES hudStr:@"正在加载....."];
    
}


/**
 家访订单首单免费单独接口
 @param homeServiceId 如果订单价格为0 ,则调用该接口,如果不为0 ,则调用选择支付方式,然后支付的接口
 */
- (void)loadDataSingleFree:(NSString* )homeServiceId{
    
    NSDictionary* paramsDic = @{@"homeServiceId":homeServiceId};
    [VDNetRequest HH_RequestHandle:paramsDic
                               URL:kURL(@"user/home/udpateUserServiceHomeStateToPay.html")
                    viewController:self
                           success:^(id responseObject) {
                               
                               VD_ShowBGBackError(NO);
                               [self.navigationController popViewControllerAnimated:YES];
                           } failureEndRefresh:^{
                               
                           } showHUD:NO hudStr:@""];
}



-(SZRTableView *)tableView{
    if (!_tableView) {
        _tableView = [[SZRTableView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight - 64) style:UITableViewStylePlain controller:self];
        _tableView.contentInset = UIEdgeInsetsMake(k6P_3AdaptedHeight(50), 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 || indexPath.row == 5) {
        OrderAddressCell * addressCell = [tableView dequeueReusableCellWithIdentifier:@"OrderAddressCell" forIndexPath:indexPath];
        addressCell.titleLabel.text = indexPath.row == 1 ? @"前往地址" : @"其他需求";
        addressCell.addressTextView.text = indexPath.row == 1 ? _selectModel.serviceAddress : _selectModel.otherService ;
        return addressCell;
    }
    if (indexPath.row == 2) {
        NamePhoneNumCell * namePhoneCell = [tableView dequeueReusableCellWithIdentifier:@"NamePhoneNumCell" forIndexPath:indexPath];
        namePhoneCell.nameTF.text = _selectModel.serviceContact;
        namePhoneCell.phoneNum.text = _selectModel.servicePhone;
        return namePhoneCell;
    }else{
    
        OrderLabelAndTFCell * orderCell = [tableView dequeueReusableCellWithIdentifier:@"OrderLabelAndTFCell" forIndexPath:indexPath];
        orderCell.contentLabel.enabled = NO;
        if (indexPath.row == 0) {
            orderCell.titleLabel.text = @"预约时间";
            NSString* timeStr = [NSString stringWithFormat:@"%ld",(long)_selectModel.serviceOrderTime];
            orderCell.contentLabel.text = [NSString getTimeWithStamp:timeStr dateFormartter:@"yyyy-MM-dd"];
        }else if (indexPath.row == 3){
            orderCell.titleLabel.text = @"服务类型";
            orderCell.contentLabel.text = _selectModel.doctorServiceHome.serviceName;
        }else if (indexPath.row == 4){
            orderCell.titleLabel.text = @"服务次数";
            orderCell.contentLabel.text = [NSString stringWithFormat:@"%ld 次数",(long)_selectModel.serviceCount];
        }

        return orderCell;
    }
    return nil;
}


-(void)leftBtnClick{
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
