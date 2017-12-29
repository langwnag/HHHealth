//
//  HealthShowCell.m
//  YiJiaYi
//
//  Created by mac on 2017/6/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HealthShowCell.h"
#import "SaleGoodsModel.h"
@interface HealthShowCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/** 数据源 */
@property (nonatomic,copy) NSArray* desDataArray;
@property (nonatomic,copy) NSArray* moneyDataArray;
@property (nonatomic,copy) NSArray* oranginMoneyDataArray;

@end
@implementation HealthShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configUI];
}

- (void)configUI{
    
    kLabelThinLightColor(self.saleGoodsLa, kAdaptedWidth(36/2), HEXCOLOR(0x333333));
    kLabelThinLightColor(self.moreLa, kAdaptedWidth(18/2), HEXCOLOR(0x000000));
    
    self.bgView.userInteractionEnabled = YES;
    [self.bgView addSubview:self.collectionView];

    [self.collectionView registerClass:[SaleGoodsCell class] forCellWithReuseIdentifier:@"SaleGoodsCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //设置约束
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bgView);
    }];

}

- (void)layoutSubviews{
    [super layoutSubviews];
   
    self.topView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(kAdaptedHeight_2(98));

    self.bgView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView(self.topView,0)
    .heightIs(kAdaptedHeight_2(300));
    

    self.saleGoodsLa.sd_layout
    .leftSpaceToView(self.topView,kAdaptedWidth_2(17))
    .topSpaceToView(self.topView,kAdaptedHeight_2(35))
    .widthIs(kAdaptedWidth_2(240))
    .heightIs(kAdaptedHeight_2(33));

    self.moreLa.sd_layout
    .rightSpaceToView(self.topView,kAdaptedWidth_2(17))
    .centerYEqualToView(self.saleGoodsLa)
    .widthIs(kAdaptedWidth_2(100))
    .heightIs(kAdaptedHeight_2(33));
    
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGFloat itemSpace = (SZRScreenWidth-kAdaptedWidth_2(220)*3)/4;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = itemSpace;
        layout.sectionInset = UIEdgeInsetsMake(0, itemSpace, 0, itemSpace);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
       
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.saleGoodsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SaleGoodsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SaleGoodsCell" forIndexPath:indexPath];
    SaleGoodsModel* model = self.saleGoodsArr[indexPath.item];
    if (self.saleGoodsArr.count > 0) {
        cell.model = model;
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kAdaptedWidth_2(220), kAdaptedHeight_2(300));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    !self.clickItemBlock ? : self.clickItemBlock(indexPath);
}
- (void)setSaleGoodsArr:(NSArray *)saleGoodsArr{
    _saleGoodsArr = saleGoodsArr;
    [self.collectionView reloadData];
}
 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
