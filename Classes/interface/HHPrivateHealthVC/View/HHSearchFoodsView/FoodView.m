//
//  FoodView.m
//  YiJiaYi
//
//  Created by mac on 2017/6/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "FoodView.h"
#import "FoodItem.h"
@implementation FoodView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataMarr = [NSMutableArray array];
        [self configUI];
    }
    return self;
}
- (void)configUI{
    [self.collectionView registerClass:[FoodItem class] forCellWithReuseIdentifier:@"FoodItem"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}

- (void)reloadData{
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataMarr.count;
    SZRLog(@"%zd",self.dataMarr.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FoodItem* foodItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"FoodItem" forIndexPath:indexPath];
    foodItem.foodLa.text = self.dataMarr[indexPath.item];
    [foodItem layoutIfNeeded];
    return foodItem;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString* foodStr = self.dataMarr[indexPath.item];
    CGRect rect = [foodStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 25) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kLightFont(kFontAdaptedWidth(13))} context:nil];
    return CGSizeMake(rect.size.width+8+10, 25);
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(8, 5, 0, 5);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FoodItem* foodItem = (FoodItem* )[collectionView cellForItemAtIndexPath:indexPath];
    if ([foodItem.backgroundColor isEqual:[UIColor orangeColor]]) {
        foodItem.foodLa.textColor = [UIColor orangeColor];
        foodItem.backgroundColor = [UIColor whiteColor];
    }else{
        foodItem.foodLa.textColor = [UIColor whiteColor];
        foodItem.backgroundColor = [UIColor orangeColor];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    FoodItem* foodItem = (FoodItem* )[collectionView cellForItemAtIndexPath:indexPath];
    foodItem.foodLa.textColor = [UIColor orangeColor];
    foodItem.backgroundColor = [UIColor whiteColor];
}



@end
