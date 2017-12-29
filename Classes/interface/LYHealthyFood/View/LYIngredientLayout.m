//
//  LYIngredientLayout.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/19.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYIngredientLayout.h"
#import "LYIngredientHeaderView.h"
#import "LYIngredientFooterView.h"

#define CELL_WIDTH ([UIScreen mainScreen].bounds.size.width - 10 * 6) / 5
@interface LYIngredientLayout ()
/**
 *  布局信息
 */
@property (nonatomic, strong) NSArray *layoutInfoArr;
/**
 *  内容尺寸
 */
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) NSMutableArray * headArr;
@property (nonatomic, strong) NSMutableArray * decorationArr;

@end

static NSInteger const itemSpace = 10;
static NSInteger const headerHeight = 30;

@implementation LYIngredientLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    [self registerNib:[UINib nibWithNibName:@"LYIngredientFooterView" bundle:nil] forDecorationViewOfKind:@"UICollectionElementKindSectionDecoration"];
    
    
    NSMutableArray *layoutInfoArr = [NSMutableArray array];
    NSInteger maxNumberOfItems = 0;
    //获取布局信息
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++){
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *subArr = [NSMutableArray arrayWithCapacity:numberOfItems];
        for (NSInteger item = 0; item < numberOfItems; item++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [subArr addObject:attributes];
        }
        if(maxNumberOfItems < numberOfItems){
            maxNumberOfItems = numberOfItems;
        }
        //添加到二维数组
        [layoutInfoArr addObject:[subArr copy]];
    }
    for (NSInteger i = 0; i < numberOfSections; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        UICollectionViewLayoutAttributes * att = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [self.headArr addObject:att];
        
        UICollectionViewLayoutAttributes * att2 = [self layoutAttributesForDecorationViewOfKind:@"UICollectionElementKindSectionDecoration" atIndexPath:indexPath];
        [self.decorationArr addObject:att2];
    }

    //存储布局信息
    self.layoutInfoArr = [layoutInfoArr copy];
    //保存内容尺寸
    NSInteger maxSection = [self.collectionView numberOfSections];
    CGFloat contentSizeHeight = 0;
    for (NSInteger i = 0; i < maxSection; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        contentSizeHeight += [self calculateDecorationHeightWithIndexPath:indexPath] + 20;
    }
    self.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, contentSizeHeight + 64 + 49 - 20);
}

- (CGSize)collectionViewContentSize{
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *layoutAttributesArr = [NSMutableArray array];
    
    [self.decorationArr enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(obj.frame, rect)) {
            [layoutAttributesArr addObject:obj];
        }
    }];
    
    [self.layoutInfoArr enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger i, BOOL * _Nonnull stop) {
        [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(CGRectIntersectsRect(obj.frame, rect)) {
                [layoutAttributesArr addObject:obj];
            }
        }];
    }];

       [self.headArr enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(obj.frame, rect)) {
            [layoutAttributesArr addObject:obj];
        }
    }];
    return layoutAttributesArr;
}
//layout header
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    attributes.frame = CGRectMake(0, [self getHeightWithIndexPath:indexPath] + headerHeight * indexPath.section, [UIScreen mainScreen].bounds.size.width, headerHeight);
    return attributes;
}
//layout decoration
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"UICollectionElementKindSectionDecoration" withIndexPath:indexPath];
    CGFloat baseY = [self getHeightWithIndexPath:indexPath] + indexPath.section * headerHeight;
    attributes.frame = CGRectMake(0, baseY, [UIScreen mainScreen].bounds.size.width, [self calculateDecorationHeightWithIndexPath:indexPath]);
    attributes.zIndex = -1;
    return attributes;
}
//layout item
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat baseY = [self getHeightWithIndexPath:indexPath];

    if (indexPath.row == 0) {
        attributes.frame = CGRectMake(itemSpace, (indexPath.section + 1 )* headerHeight + itemSpace + baseY, CELL_WIDTH * 2 + 10, CELL_WIDTH + 10);
        
    }else if (indexPath.row >= 1 && indexPath.row <= 6){
        attributes.frame = CGRectMake((itemSpace + CELL_WIDTH) * 2 + itemSpace + (indexPath.row - 1) % 3 * (CELL_WIDTH + itemSpace ),(indexPath.section + 1 ) * headerHeight + baseY + itemSpace + (indexPath.row - 1) / 3 * (CELL_WIDTH / 2 + 10), CELL_WIDTH, CELL_WIDTH / 2);
        
    }else{
        attributes.frame = CGRectMake(itemSpace + (CELL_WIDTH + itemSpace) * ((indexPath.row + 3) % 5), (indexPath.section + 1 ) * headerHeight + baseY + itemSpace + (itemSpace + CELL_WIDTH / 2) * ((indexPath.row + 3) / 5), CELL_WIDTH, CELL_WIDTH / 2);
    }
    return attributes;
}

- (CGFloat)getHeightWithIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat baseY = 0;
    for (NSInteger i = 0; i < indexPath.section; i++) {
        NSInteger itemNum = [self.collectionView numberOfItemsInSection:i];
        CGFloat remainRowNum = ((itemNum - 7) % 5 == 0 ? 0 : 1) + (itemNum - 7) / 5;
        baseY += itemNum > 7 ? ((itemSpace + CELL_WIDTH / 2) * 2 + remainRowNum * (CELL_WIDTH / 2 + itemSpace)) : ((itemSpace + CELL_WIDTH / 2) * 2);
    }
    return (baseY + headerHeight * indexPath.section);
}

- (CGFloat)calculateDecorationHeightWithIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:indexPath.section];
    CGFloat cellHeightSum = 0;
    if (numberOfItems <= 7) {
        cellHeightSum += (CELL_WIDTH / 2 + 10) * 2;
    }else{
        cellHeightSum += (CELL_WIDTH / 2 + 10) * 2 + ((numberOfItems - 7) / 5 + ((numberOfItems - 7) % 5 == 0 ? 0 : 1)) * (CELL_WIDTH / 2 + itemSpace);
    }
    cellHeightSum += (headerHeight + itemSpace);
    return cellHeightSum;
}

- (NSMutableArray *)headArr{
    if (!_headArr) {
        _headArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _headArr;
}

- (NSMutableArray *)decorationArr{
    if (!_decorationArr) {
        _decorationArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _decorationArr;
}
@end
