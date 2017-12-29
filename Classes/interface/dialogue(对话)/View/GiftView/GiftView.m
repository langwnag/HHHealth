//
//  GiftView.m
//  YiJiaYi
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "GiftView.h"
#import "GiftCell.h"
@interface GiftView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *Arr;

@property (nonatomic, strong) NSMutableArray *modelArr;
// 记录加载次数
@property (nonatomic,assign) BOOL isFirstLoad;



@end
@implementation GiftView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupGiftView];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.Arr = [NSArray array];
        self.modelArr = [NSMutableArray array];
        [self setupGiftView];
    }
    return self;
}

- (void)setupGiftView{
//    self.sendBtn.backgroundColor = [UIColor lightGrayColor];
    self.sendBtn.backgroundColor = [UIColor colorWithRed:75/255.0 green:211/255.0 blue:179/255.0 alpha:1];
    self.sendBtn.enabled = YES;
    
    self.frame = CGRectMake(0, 0, SZRScreenWidth, SZRScreenWidth / 2+35+1);
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(GiftCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(GiftCell.class)];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        blurView.frame = self.bounds;
        [self insertSubview:blurView atIndex:0];
    } else {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    self.isFirstLoad = YES;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupGiftView];
    self.sendBtn.layer.cornerRadius = 17.5f;
    self.sendBtn.layer.masksToBounds = YES;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.pageControl.numberOfPages = 32 / 8;
    return 32;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GiftCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(GiftCell.class) forIndexPath:indexPath];
    if (self.isFirstLoad && indexPath.item == 0) {
        cell.selected = YES;
        self.isFirstLoad = NO;
    }
    [cell.giftCountBtn setTitle:[NSString stringWithFormat:@"%ld",(indexPath.row +1 ) * 10] forState:UIControlStateNormal];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SZRScreenWidth / 4, SZRScreenWidth / 4);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item !=0) {
        GiftCell* cell = (GiftCell* )[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        cell.selected = NO;
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = (int)scrollView.contentOffset.x / scrollView.width;
}
- (IBAction)sendBtnDidClicked:(UIButton *)sender {
    GiftCell* cell = (GiftCell* )[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    NSIndexPath* currentIndexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
    if (currentIndexPath) {
        GiftCell* item = (GiftCell* )[self.collectionView cellForItemAtIndexPath:currentIndexPath];
        if ([self.delegate respondsToSelector:@selector(giftView:sendBtnDidClickedWithFCount:)]) {
            [self.delegate giftView:self sendBtnDidClickedWithFCount:item.giftCountBtn.titleLabel.text];
        }
    }else if (cell.selected){
        if ([self.delegate respondsToSelector:@selector(giftView:sendBtnDidClickedWithFCount:)]) {
            [self.delegate giftView:self sendBtnDidClickedWithFCount:cell.giftCountBtn.titleLabel.text];
        }
    }

}
- (IBAction)goToRechargeDidClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(giftView:rechargeBtnDidClicked:)]) {
        [self.delegate giftView:self rechargeBtnDidClicked:sender];
    }
    SZRLog(@"前去充值吧老帅哥");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
