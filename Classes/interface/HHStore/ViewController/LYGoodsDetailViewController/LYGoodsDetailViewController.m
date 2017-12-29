//
//  LYGoodsDetailViewController.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYGoodsDetailViewController.h"
#import "LYGoodDetailHeadView.h"
#import "LYFunctionLabView.h"
#import "LYGoodDetailCell.h"
#import "LYFunctionBtnView.h"
#import "LYInsureOrderViewController.h"
#import "LYGoodDetailModel.h"
#import "ConfirmOrderVC.h"
#import "UIImage+WebSize.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface LYGoodsDetailViewController ()<LYFunctionBtnViewDelegate>

@property (nonatomic, strong) LYGoodDetailHeadView * headView;
@property (nonatomic, strong) LYFunctionBtnView * footView;
@property (nonatomic, strong) LYFunctionLabView * sectionHeadView;
@property (nonatomic, strong) LYGoodDetailModel * detailModel;

@end

static CGFloat const headViewHeight = 315.0f;
static CGFloat const footViewHeight = 60.0f;
static CGFloat const sectionHeadHeight = 50.0f;

@implementation LYGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:@{NAVTITLE : self.navTitle, NAVLEFTIMAGE:kBackBtnName}];
    [self configTableView];
    [self.view addSubview:self.footView];
    if (self.footerState == NO) {
        self.footView.hidden = NO;
    }else{
        self.footView.hidden = YES;
        CGRect newFrame = self.tableView.frame;
        newFrame.size.height = [UIScreen mainScreen].bounds.size.height  - 64.0f;
        self.tableView.frame = newFrame;
    }
    
    [self requestNetData];
}

- (void)configTableView{

    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height  - footViewHeight - 64.0f);
    self.tableView.tableHeaderView = self.headView;
    if (self.footerState == YES) {
        self.headView.goodDiscountLab.hidden = YES;
        self.headView.goodOriginalLab.hidden = YES;
       
    }
    [self.tableView registerClass:[LYGoodDetailCell class] forCellReuseIdentifier:@"LYGoodDetailCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)requestNetData{
    
    NSDictionary* paramsDic = @{@"commodityId":[NSString stringWithFormat:@"%ld", self.commodityId]};
    [VDNetRequest HH_RequestHandle:paramsDic
                               URL:kURL(@"commodity/selectCommodityDetailById.html")
                    viewController:self
                           success:^(id responseObject) {
                               NSString * jsonStr = [RSAAndDESEncrypt DESDecrypt:responseObject[DATA]];
//                               SZRLog(@"商品详情 %@",jsonStr);
                               LYGoodDetailModel * model = [LYGoodDetailModel whc_ModelWithJson:jsonStr];
                               self.detailModel = model;
                               [self addNewData:[NSMutableArray arrayWithArray:model.commodityPictureList] totalCount:0];
                               [self reloadHeadViewWithModel:model];
                               
                           } failureEndRefresh:^{
                               
                           } showHUD:NO hudStr:@""];
    
    
}

- (void)reloadHeadViewWithModel:(LYGoodDetailModel *)model{
    [self.headView setDataWithModel:model];
    if (self.footerState == YES) {
    self.headView.goodDescLab.text = self.headView.goodDescLab.text ? [[NSUserDefaults standardUserDefaults] objectForKey:@"address"] : @"";
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return sectionHeadHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommodityPictureList * listModel = self.tableViewData[indexPath.row];
    
    CGSize size = [UIImage getImageSizeWithURL:listModel.pictureUrl];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width * size.height / size.width;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYGoodDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LYGoodDetailCell"];
    if (self.tableViewData.count > 0) {
        CommodityPictureList * listModel = self.tableViewData[indexPath.row];
        [cell.goodImageView sd_setImageWithURL:[NSURL URLWithString:listModel.pictureUrl] placeholderImage:[UIImage imageNamed:@"goodsDefaultImage"]];
    }
    return cell;
}

#pragma mark - lazy load
- (LYGoodDetailHeadView *)headView{
    if (!_headView) {
        _headView = [[LYGoodDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headViewHeight)];
    }
    return _headView;
}

- (LYFunctionBtnView *)footView{
    if (!_footView) {
        _footView = [[LYFunctionBtnView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - footViewHeight - 64, SCREEN_WIDTH, footViewHeight)];
        _footView.delegate = self;
    }
    return _footView;
}

- (LYFunctionLabView *)sectionHeadView{
    if (!_sectionHeadView) {
        _sectionHeadView = [[LYFunctionLabView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, sectionHeadHeight)];
    }
    return _sectionHeadView;
}

#pragma mark - LYFunctionBtnViewDelegate
//点击购买按钮
- (void)clickFunctionBtn:(UIButton *)btn{

    ConfirmOrderVC* addressVC = [[ConfirmOrderVC alloc] init];
    addressVC.goodsImgUrl = self.detailModel.attributeUrl;
    addressVC.goodsName = self.detailModel.name;
    addressVC.commodityPrice = self.detailModel.discountPrice;
    [self.navigationController pushViewController:addressVC animated:YES];
}
@end
