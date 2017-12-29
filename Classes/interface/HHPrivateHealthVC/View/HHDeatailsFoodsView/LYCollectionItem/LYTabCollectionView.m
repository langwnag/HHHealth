//
//  LYTabCollectionView.m
//  HUGHIOIJOGERJIOGRE
//
//  Created by Mr.Li on 2017/6/30.
//  Copyright © 2017年 Mr.Li. All rights reserved.
//

#import "LYTabCollectionView.h"
#import "LYTabsCell.h"

@interface LYTabCollectionView ()

@property (nonatomic, strong) UICollectionView      * collectionView;

@end

static CGFloat const itemHeight = 30;
static CGFloat const itemLineSpace = 10;

@implementation LYTabCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LYTabsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYTabsCell" forIndexPath:indexPath];
    if (self.dataArr.count > 0) {
        cell.title = self.dataArr[indexPath.row];
    }
    if ((self.dataArr.count - 1) == indexPath.row) {
        [self changeFrame];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count > 0) {
        NSString * title = self.dataArr[indexPath.row];
        CGFloat cellWidth = [self getWidthWithString:title height:itemHeight font:15];
        return CGSizeMake(cellWidth + itemLineSpace * 2, itemHeight);
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectEffect) {
        LYTabsCell * cell = (LYTabsCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor orangeColor];
        cell.titleLabTextColor = [UIColor whiteColor];
    }
    if (self.selectTabBlock) {
        self.selectTabBlock(self.dataArr[indexPath.row]);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectEffect) {
        LYTabsCell * cell = (LYTabsCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLabTextColor = [UIColor orangeColor];
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

- (void)changeFrame{
    self.collectionView.frame =CGRectMake(0, 0, self.frame.size.width, _collectionView.collectionViewLayout.collectionViewContentSize.height);
    CGRect rect = self.frame;
    rect.size.height = self.collectionView.frame.size.height;
    self.frame = rect;
    
    NSString * tmpHeight = [NSString stringWithFormat:@"%lf", self.collectionView.frame.size.height];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveChangeTabViewFrame" object:tmpHeight];;
}
#pragma mark - get string width
- (CGFloat)getWidthWithString:(NSString *)str height:(CGFloat)height font:(CGFloat)font{
    
    if (!str)
        return 0;
    CGSize size = [str boundingRectWithSize:CGSizeMake(0, height)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                    context:nil].size;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat tmpWidth = size.width >= (screenWidth - itemLineSpace * 4) ? (screenWidth - itemLineSpace * 4) : size.width;
    return tmpWidth;
}

#pragma mark - rewrite set method
- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.collectionView reloadData];
}
#pragma mark - lazy load
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"LYTabsCell" bundle:nil] forCellWithReuseIdentifier:@"LYTabsCell"];
    }
    return _collectionView;
}
@end
