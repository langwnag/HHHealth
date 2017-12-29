//
//  LYHealthyFoodViewController.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYHealthyFoodViewController.h"
#import "LYIngredientNameCell.h"
#import "LYIngredientImageCell.h"
#import "LYIngredientLayout.h"
#import "LYIngredientHeaderView.h"
#import "LYPromptView.h"
#import "LYHealthFoodModel.h"
#import "LYFoodDetailViewController.h"
#import "LYStoreMainViewController.h"

@interface LYHealthyFoodViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView  * collectionView;
@property (nonatomic, strong) NSMutableArray    * dataArr;

@end

@implementation LYHealthyFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavItems:@{NAVTITLE:@"食材",NAVLEFTIMAGE:kBackBtnName}];
    [self.view addSubview:self.collectionView];
    [self requestData];
}

- (void)requestData{

    NSDictionary * patameters = @{@"methodName":@"ApiFoodType", @"appid":@"225858ca5671aca4658eef91fe445a87", @"appkey":@"f533b9849bcf7493"};
    [VDNetRequest COOKING_RequestHandle:patameters
                         viewController:self
                                success:^(id responseObject) {
                                    LYHealthFoodModel * model = [LYHealthFoodModel whc_ModelWithJson:responseObject];
                                    [self.dataArr addObjectsFromArray:model.data.data];
                                    [self.collectionView reloadData];
                                    
                                } failureEndRefresh:^{
        
                                } showHUD:NO
                                 hudStr:@""];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewFlowLayout

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        LYIngredientHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LYIngredientHeaderView" forIndexPath:indexPath];
        if (self.dataArr.count > 0) {
            LYHealthFoodSecData * model = self.dataArr[indexPath.section];
            headerView.title = model.text;
        }
        return headerView;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArr.count > 0) {
        LYHealthFoodSecData * model = self.dataArr[section];
        return model.data.count + 1;
    }
    return 0;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    LYIngredientImageCell * imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYIngredientImageCell" forIndexPath:indexPath];
    LYIngredientNameCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYIngredientNameCell" forIndexPath:indexPath];
    
    if (self.dataArr.count > 0) {

        LYHealthFoodSecData * secDataModel = self.dataArr[indexPath.section];
        if (indexPath.row == 0) {
            NSURL * url = [NSURL URLWithString:secDataModel.image];
            [imageCell.ingredientImageView sd_setImageWithURL:url placeholderImage:nil];
            return imageCell;
        }else{
            LYHealthFoodThridData * thirdData = [secDataModel.data objectAtIndex:(indexPath.row - 1)];
            cell.title = thirdData.text;
            return cell;
        }
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        LYHealthFoodSecData * secDataModel = self.dataArr[indexPath.section];
        LYHealthFoodThridData * thirdData = [secDataModel.data objectAtIndex:(indexPath.row - 1)];
        LYFoodDetailViewController * vc = [[LYFoodDetailViewController alloc] init];
        vc.materialId = thirdData.fourId;
        vc.imageStr = thirdData.image;
        vc.navTitle = thirdData.text;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - Lazy init
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        LYIngredientLayout * layout = [[LYIngredientLayout alloc] init];
        layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 30);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xf8f8f8);
        [_collectionView registerNib:[UINib nibWithNibName:@"LYIngredientNameCell" bundle:nil] forCellWithReuseIdentifier:@"LYIngredientNameCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"LYIngredientImageCell" bundle:nil] forCellWithReuseIdentifier:@"LYIngredientImageCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"LYIngredientHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LYIngredientHeaderView"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}
@end
