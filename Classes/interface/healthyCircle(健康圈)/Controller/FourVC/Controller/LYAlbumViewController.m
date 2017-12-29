//
//  LYAlbumViewController.m
//  LYMoment
//
//  Created by Leaf on 2017/5/18.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import "LYAlbumViewController.h"
#import "LYAlbumCell.h"
#import "HealthCircleModel.h"

@interface LYAlbumViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionView;
@end

@implementation LYAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"LYAlbumCell" bundle:nil] forCellWithReuseIdentifier:@"LYAlbumCell"];
        
    }
    return _collectionView;
}

#pragma  mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LYAlbumCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYAlbumCell" forIndexPath:indexPath];

    if (self.dataArr.count > 0) {
        
        HealthCircleModel* circleModel = self.dataArr[indexPath.row];
        for (PictureModel* pictModel in circleModel.hhHealthyCirclePicture) {
            NSURL * url  = [NSURL URLWithString:pictModel.pictureUrl];
            NSURLRequest * request = [NSURLRequest requestWithURL:url];
            [cell.webView loadRequest:request];
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - 64);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.collectionView reloadData];
}


@end
