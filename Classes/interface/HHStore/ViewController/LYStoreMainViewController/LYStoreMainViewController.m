//
//  LYStoreMainViewController.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYStoreMainViewController.h"
#import "LYFlashSaleViewController.h"
#import "LYIntelligentHardwareViewController.h"
#import "LYExaminationProductViewController.h"
#import "LYHealthInsuranceViewController.h"
#import "LYDiscountPackageViewController.h"
#import "LYStoreMainSegmentModel.h"

@interface LYStoreMainViewController ()

@property (nonatomic, strong) NSArray * segmentArr;

@end

@implementation LYStoreMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"合合商城";
    if (self.showLeftBtn) {
        [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName}];
    }else{
        self.navigationItem.hidesBackButton = YES;
    }

    [self loadDataPersonalCenter];
}

- (void)loadDataPersonalCenter{
    
    NSDictionary * dic = @{@"token":[VDUserTools VD_GetToken]};
    [VDNetRequest VD_PostWithURL:kURL(@"commodityType/selectCommodityTypeList.html")
                      arrtribute:@{VDHTTPPARAMETERS:dic}
                          finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                              NSString * jsonStr = [RSAAndDESEncrypt DESDecrypt:responseObject[DATA]];
                              NSData * data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                              NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                              if (arr.count > 0) {
                                  NSDictionary * dic = @{@"LYSegmentList":arr};
                                  LYStoreMainSegmentModel * model = [LYStoreMainSegmentModel whc_ModelWithJson:dic];
                                  self.segmentArr = [NSMutableArray arrayWithArray:model.lYSegmentList];

                              }
                              
                          } noNetwork:^{
                              
                          }];
}

- (void)setSegmentArr:(NSArray *)segmentArr{
    _segmentArr = segmentArr;
    
    self.segmentHighlightColor = [UIColor redColor];
    self.segmentControl.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), self.view.bounds.size.width, self.view.bounds.size.height - 44);
    
    LYFlashSaleViewController *vc1 = [[LYFlashSaleViewController alloc] init];
    LYSegmentList * listModel0 = segmentArr[0];
    vc1.title = listModel0.name;
    vc1.commodityId = listModel0.commodityTypeId;
    
    LYIntelligentHardwareViewController *vc2 = [[LYIntelligentHardwareViewController alloc] init];
    LYSegmentList * listModel1 = segmentArr[1];
    vc2.title = listModel1.name;
    vc2.commodityId = listModel1.commodityTypeId;
    
    LYExaminationProductViewController *vc3 = [[LYExaminationProductViewController alloc] init];
    LYSegmentList * listModel2 = segmentArr[2];
    vc3.title = listModel2.name;
    vc3.commodityId = listModel2.commodityTypeId;
    
    LYHealthInsuranceViewController *vc4 = [[LYHealthInsuranceViewController alloc] init];
    LYSegmentList * listModel3 = segmentArr[3];
    vc4.title = listModel3.name;
    vc4.commodityId = listModel3.commodityTypeId;
    
    LYDiscountPackageViewController *vc5 = [[LYDiscountPackageViewController alloc] init];
    LYSegmentList * listModel4 = segmentArr[4];
    vc5.title = listModel4.name;
    vc5.commodityId = listModel4.commodityTypeId;
    
    self.viewControllers = @[vc1, vc2, vc3, vc4, vc5];

}

@end
