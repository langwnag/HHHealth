//
//  SendServiceOrderVC.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SendServiceOrderVC.h"
#import "OrderLabelAndTFCell.h"
#import "NamePhoneNumCell.h"
#import "OtherNeedFooterView.h"
#import "OrderAddressCell.h"
#import "ServiceTimesCell.h"
#import "SZRTextview.h"
#import "DoctListModel.h"
#import "ServiceTypeModel.h"
#import "ChatTextVC.h"
#import "SelectFamilyVisitModel.h"
@interface SendServiceOrderVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)SZRTableView * tableView;

@property(nonatomic,strong)NSArray * serviceTypes;

@end

@implementation SendServiceOrderVC
{
    CGFloat _totalKeybordHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)configUI{
    
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"发起服务订单"}];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.estimatedRowHeight = k6P_3AdaptedHeight(136);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderLabelAndTFCell" bundle:nil] forCellReuseIdentifier:@"OrderLabelAndTFCell"];
    [self.tableView registerClass:[OrderAddressCell class] forCellReuseIdentifier:@"OrderAddressCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NamePhoneNumCell" bundle:nil] forCellReuseIdentifier:@"NamePhoneNumCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ServiceTimesCell" bundle:nil] forCellReuseIdentifier:@"ServiceTimesCell"];
    
    OtherNeedFooterView * footerView = [[OtherNeedFooterView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, k6P_3AdaptedHeight(600))];
    footerView.sendServiceBlock = ^(){
    
        [self sendServiceRequest];
    };
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
}

-(SZRTableView *)tableView{
    if (!_tableView) {
        _tableView = [[SZRTableView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight - 64) style:UITableViewStylePlain controller:self];
        _tableView.contentInset = UIEdgeInsetsMake(k6P_3AdaptedHeight(50), 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTableView)];
        [_tableView addGestureRecognizer:tap];
    }
    return _tableView;
}
 -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        OrderAddressCell * addressCell = [tableView dequeueReusableCellWithIdentifier:@"OrderAddressCell" forIndexPath:indexPath];
        return addressCell;
    }
    
    if (indexPath.row == 2) {
        NamePhoneNumCell * namePhoneCell = [tableView dequeueReusableCellWithIdentifier:@"NamePhoneNumCell" forIndexPath:indexPath];
        
        return namePhoneCell;
    }
    
    if (indexPath.row == 4) {
        ServiceTimesCell* serviceTimesCell = [tableView dequeueReusableCellWithIdentifier:@"ServiceTimesCell" forIndexPath:indexPath];
       
        return serviceTimesCell;
    }
    
    else{
        OrderLabelAndTFCell * orderCell = [tableView dequeueReusableCellWithIdentifier:@"OrderLabelAndTFCell" forIndexPath:indexPath];
  
        orderCell.titleLabel.text = indexPath.row == 0 ? @"预约时间" : @"服务类型";
        
        __weak typeof(orderCell) weakOrderCell = orderCell;
        if (indexPath.row == 3) {
            orderCell.serviceTypeBlock = ^(){
                
                [self loadServiceTypes:^(NSArray *serviceTypeArr) {
                    weakOrderCell.serviceTypes = serviceTypeArr;
                    [weakOrderCell showServiceTypePickerView];
                }];
            };
        }
        return orderCell;
    }
}

//加载服务类型
-(void)loadServiceTypes:(void(^)(NSArray * serviceTypeArr))successArr{
    SZRLog(@"self.doctorModel.agentCompanyId = %@ self.doctorModel.hhDoctorLevel = %@",self.doctorModel.agentCompanyId,self.doctorModel.doctorLevelId);
    NSDictionary * paramDic = @{@"agentCompanyId":self.doctorModel.agentCompanyId,@"doctorLevelId":self.doctorModel.doctorLevelId};
    [VDNetRequest HH_GetServiceType:paramDic viewController:self success:^(NSArray *dic) {
        NSArray * serviceTypeArr = [ServiceTypeModel mj_objectArrayWithKeyValuesArray:dic];
        if (successArr) {
            successArr(serviceTypeArr);
        }
    }];
}

//发起服务请求
-(void)sendServiceRequest{
    NSString * time = [(OrderLabelAndTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] contentLabel].text;
    NSString * address = [(OrderAddressCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] addressTextView].text;
    NamePhoneNumCell * nameAndPhoneCell = (NamePhoneNumCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    ServiceTimesCell* serviceTimesCell = (ServiceTimesCell* )[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString * serviceTimes = serviceTimesCell.numTextField.text;
    NSString * contactName = nameAndPhoneCell.nameTF.text;
    NSString * phoneNum = nameAndPhoneCell.phoneNum.text;
    NSNumber * serviceTypeID = [(OrderLabelAndTFCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] serviceId];
    NSString * otherService = [[(OtherNeedFooterView *)self.tableView.tableFooterView otherNeedTextView]textView].text;
    
    if (time.length <= 0 || address.length <= 0 || contactName.length <= 0 || phoneNum.length <= 0 || serviceTimes.length <= 0 || !serviceTypeID) {
        [MBProgressHUD showTextOnly:@"请填写完整订单"];
    }else if(![SZRFunction VD_CheckPhoneNum:phoneNum]){
        [MBProgressHUD showTextOnly:@"手机号码格式不正确"];
    }else{
        long long timeStamp = [NSDate timeStampWithString:time];
        NSDictionary * paramDic = @{@"doctorId":self.doctorModel.doctorId,
                                    @"serviceTime":@(timeStamp),
                                    @"serviceAddress":address,
                                    @"serviceContact":contactName,
                                    @"servicePhone":phoneNum,
                                    @"serviceId":serviceTypeID,
                                    @"otherService":otherService,
                                    @"serviceCount":serviceTimes};
        [VDNetRequest HH_RequestHandle:paramDic URL:HH_FamilyVisit_URL viewController:self success:^(id responseObject) {
            [MBProgressHUD showTextOnly:responseObject[MESSAGE] hideBeforeShow:YES];
            
            SelectFamilyVisitModel* model = [SelectFamilyVisitModel mj_objectWithKeyValues:[RSAAndDESEncrypt DESDecryptResponseObject:responseObject]];
            
            if (self.comitVisistBlock) {
                self.comitVisistBlock([NSString stringWithFormat:@"%ld", model.homeServiceId]);
            }
            //请求成功之后在返回
            [self.navigationController popViewControllerAnimated:YES];
        } failureEndRefresh:^{
            
        } showHUD:YES hudStr:@""];
        
    }
    
}



- (void)keyboardNotification:(NSNotification *)notification
{
    OtherNeedFooterView * footerView = (OtherNeedFooterView *)self.tableView.tableFooterView;
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat h = rect.size.height + 5;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect textViewRect = [footerView convertRect:footerView.otherNeedTextView.frame toView:window];
    CGFloat delta = CGRectGetMaxY(textViewRect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}


-(void)tapTableView{
    [self.view endEditing:YES];
}

-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}





@end
