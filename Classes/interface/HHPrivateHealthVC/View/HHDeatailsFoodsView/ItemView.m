//
//  ItemView.m
//  YiJiaYi
//
//  Created by mac on 2017/6/27.
//  Copyright © 2017年 mac. All rights reserved.
//


#import "ItemView.h"
#import "ItemCell.h"
@interface ItemView ()<UICollectionViewDelegate,UICollectionViewDataSource>
/** UICollectionView */
@property (nonatomic,strong) UICollectionView* collectionView;
/** 图片数组 */
@property (nonatomic,copy) NSArray* imgArr;

@end
@implementation ItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (NSArray *)imgArr{
    if (!_imgArr) {
        _imgArr = @[@"difficulty",@"clock",@"taste"];
    }
    return _imgArr;
}


- (void)setDesArray:(NSArray *)desArray{
    _desArray = desArray;
    [self.collectionView reloadData];
}
- (void)configUI{
    [self addSubview:self.collectionView];
    // 应该从这里添加约束
    self.collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self.collectionView registerClass:[ItemCell class] forCellWithReuseIdentifier:@"ItemCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell* itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    itemCell.iconImg.image = IMG(self.imgArr[indexPath.item]);
    itemCell.desLa.text = self.desArray[indexPath.item];
    [itemCell layoutIfNeeded];
    return itemCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kAdaptedWidth_2(110), 45);
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGFloat itemSpace = (SZRScreenWidth-kAdaptedWidth_2(110)*3)/4;
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = itemSpace;
        layout.sectionInset = UIEdgeInsetsMake(kAdaptedHeight_2(18), kAdaptedWidth_2(35), kAdaptedHeight_2(18), kAdaptedWidth_2(35));
        // 这里设置frame是无效的
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

@end
