//
//  VisitRecordBaseVC.m
//  YiJiaYi
//
//  Created by mac on 2017/5/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "VisitRecordBaseVC.h"
#import "HHVisitRecordCell.h"
#import "NSString+LYString.h"
#import "SelectFamilyVisitModel.h"
#import "PayVC.h"

@interface VisitRecordBaseVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation VisitRecordBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
    
}

- (void)requestNetDataWithReceiveStatus:(NSString *)receiveStatus{
    
    NSMutableDictionary* dataDic = [NSMutableDictionary dictionaryWithDictionary:@{@"page":[NSString stringWithFormat:@"%ld", self.tablePage]}];
    
    if (receiveStatus.length != 0) {
        [dataDic setObject:receiveStatus forKey:@"serviceOrderState"];
    }
    
    [VDNetRequest HH_SelectFamilyVisit:dataDic
                               success:^(NSArray *arr) {
                                
                                   NSArray* selectFamilyArr = [SelectFamilyVisitModel mj_objectArrayWithKeyValuesArray:arr];
                                   [self addNewData:[NSMutableArray arrayWithArray:selectFamilyArr] totalCount:0];
                                   
                               } BGError:^(id responseObject) {
                                   
                               } endRefresh:^{
                                   
                               } viewController:self];
    
    
}

- (void)configTableView{
    self.tablePage = 1;
    self.tableLimit = 10;
    [self setTableViewIsHaveRefreshFooter:YES];
    [self setTableViewIsHaveRefreshHeader:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44 - 64);
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"HHVisitRecordCell" bundle:nil] forCellReuseIdentifier:@"HHVisitRecordCell"];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tableViewData.count > 0) {
        return self.tableViewData.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectFamilyVisitModel* model = self.tableViewData[indexPath.row];
    if ([model.serviceOrderState isEqualToString:@"DOCTOR_PRICE"] || [model.serviceOrderState isEqualToString:@"PAY_COMPLETE"] || [model.serviceOrderState isEqualToString:@"DOCTOR_GO"]) {
        return 434-73;
    }else{
        return 434;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHVisitRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HHVisitRecordCell"];
    if (self.tableViewData.count > 0) {
        SelectFamilyVisitModel* model = self.tableViewData[indexPath.row];
        cell.visitsModel = model;
        // 订单状态
        cell.visitStatus = [self getOrderStatusWithCode:model.serviceOrderState];
        __weak VisitRecordBaseVC * weakSelf = self;
        cell.leftBtnClickBlock = ^(){
            
        };
        cell.rightBtnClickBlock = ^(){
            
            [weakSelf cancelVisitOrderWithHomeServiceId:[NSString stringWithFormat:@"%ld", model.homeServiceId] indexPath:indexPath];
        };
    }
    return cell;
}

- (NSString *)getOrderStatusWithCode:(NSString *)code{

    if ([code isEqualToString:@"DOCTOR_PRICE"]) {
        return @"订单已提交";
    }else if ([code isEqualToString:@"PAY_WAIT"]){
        return @"订单已被确认";
    }else if ([code isEqualToString:@"SERVER_REFUSE"]){
        return @"订单已被拒绝";
    }else if ([code isEqualToString:@"SERVER_OUTTIME"]){
        return @"订单已过期";
    }else if ([code isEqualToString:@"PAY_COMPLETE"]){
        return @"订单已支付";
    }else if ([code isEqualToString:@"SERVER_COMPLETE"]){
        return @"订单已完成";
    }else if ([code isEqualToString:@"DOCTOR_GO"]){
        return @"服务中";
    }
    return nil;
}


/**
 取消订单
 
 @param homeServiceId 服务id
 @param indexPath
 */
- (void)cancelVisitOrderWithHomeServiceId:(NSString *)homeServiceId indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * parameter = @{@"homeServiceId":homeServiceId};
//
//    [VDNetRequest VD_PostWithURL:HH_FamilyVisitOrderCancel_Url
//                      arrtribute:@{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:parameter
//                                                                              token:YES]}
//                          finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
//        
//                              HHBaseModel * model = [HHBaseModel whc_ModelWithJson:responseObject];
//                              if (model.result) {
//                                  
//                                  NSLog(@"111111111111");
//                              }
//                          } noNetwork:^{
//        
//   
//                          }];
    __weak VisitRecordBaseVC * weakSelf = self;
    [VDNetRequest HH_RequestHandle:parameter
                               URL:HH_FamilyVisitOrderCancel_Url
                    viewController:self
                           success:^(id responseObject) {
        
                               [weakSelf.tableViewData removeObjectAtIndex:indexPath.row];
                               [weakSelf.tableView reloadData];
                           }
                 failureEndRefresh:^{
                     
                     
                 }
                           showHUD:NO
                            hudStr:nil];

}
@end
