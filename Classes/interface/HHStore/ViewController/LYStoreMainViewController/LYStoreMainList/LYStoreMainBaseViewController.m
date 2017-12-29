//
//  LYStoreMainBaseViewController.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYStoreMainBaseViewController.h"
#import "LYStoreMainCell.h"
#import "ShopShowCell.h"
#import "LYGoodsDetailViewController.h"
#import "LYStoreMainListModel.h"

@interface LYStoreMainBaseViewController ()

@end

@implementation LYStoreMainBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tablePage = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self configTableView];
    [self configCollectionView];
}

- (void)requestNetDataWithReceiveStatus:(NSString *)receiveStatus{
    
    NSDictionary* paramsDic = @{@"commodityTypeId":receiveStatus, @"page":[NSString stringWithFormat:@"%ld", self.tablePage]};
    [VDNetRequest HH_RequestHandle:paramsDic
                               URL:kURL(@"commodity/selectCommodityByTypeId.html")
                    viewController:self
                           success:^(id responseObject) {

                                NSString * jsonStr = [RSAAndDESEncrypt DESDecrypt:responseObject[DATA]];
                                   NSData * data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                                   NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   if (arr.count > 0) {
                                       NSDictionary * dic = @{@"LYStoreMainDetail":arr};
                                       LYStoreMainListModel * model = [LYStoreMainListModel whc_ModelWithJson:dic];
                                       [self addNewData:[NSMutableArray arrayWithArray:model.lYStoreMainDetail] totalCount:0];
                                   }
                           } failureEndRefresh:^{
                               
                           } showHUD:NO hudStr:@""];

    
}

- (void)configCollectionView{
    self.tablePage = 0;
    self.tableLimit = 10;
    [self setTableViewIsHaveRefreshHeader:YES];
    [self setTableViewIsHaveRefreshFooter:YES];
   
    self.collectionView.showsHorizontalScrollIndicator = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:kShopShowCell bundle:nil] forCellWithReuseIdentifier:kShopShowCell];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShopShowCell* itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopShowCell forIndexPath:indexPath];
    if (self.tableViewData.count > 0) {
        LYStoreMainDetail* model = self.tableViewData[indexPath.row];
        itemCell.goodModel = model;
    }
    return itemCell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tableViewData.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SZRScreenWidth -8-8-8)/2, 207);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableViewData.count > 0) {
        LYGoodsDetailViewController * vc = [[LYGoodsDetailViewController alloc] init];
        LYStoreMainDetail * model = self.tableViewData[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        vc.commodityId = model.commodityId;
        vc.navTitle = model.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
- (void)configTableView{
    self.tablePage = 0;
    self.tableLimit = 10;
    [self setTableViewIsHaveRefreshFooter:YES];
    [self setTableViewIsHaveRefreshHeader:YES];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44);
    [self.tableView  registerNib:[UINib nibWithNibName:@"LYStoreMainCell" bundle:nil] forCellReuseIdentifier:@"LYStoreMainCell"];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableViewData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 194;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LYStoreMainCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LYStoreMainCell"];
    if (self.tableViewData.count > 0) {
        LYStoreMainDetail * model = self.tableViewData[indexPath.row];
        [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.attributeUrl] placeholderImage:[UIImage imageNamed:@"goodsDefaultImage"]];
        cell.commodityName = model.name;
        cell.commdityPrice = [NSString stringWithFormat:@"%.2lf", model.discountPrice];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableViewData.count > 0) {
        LYGoodsDetailViewController * vc = [[LYGoodsDetailViewController alloc] init];
        LYStoreMainDetail * model = self.tableViewData[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        vc.commodityId = model.commodityId;
        vc.navTitle = model.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
*/
@end
