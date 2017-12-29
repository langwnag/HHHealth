//
//  RecordGridCell.m
//  YiJiaYi
//
//  Created by mac on 2016/12/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "RecordGridCell.h"
#import "RecordSubGrigCell.h"
#define ItemDateArr @[@"2017-04-17",@"2017-04-19",@"2017-04-17",@"2017-04-19"]
#define ItemDesArr @[@"基因检测报告",@"基因检测报告",@"基因检测报告",@"基因检测报告"]

@implementation RecordGridCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        [self createSubLabel];
        [self createUI];
        
    }
    return self;
}

//// 添加到cell上
//- (void)createSubLabel{
//    self.topView = [UIView new];
//    self.topView.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:self.topView];
//    
//}
- (void)layoutSubviews{
    [super layoutSubviews];
//    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@0);
//        make.left.right.equalTo(@0);
//        make.height.equalTo(@0.8);
//    }];
}

- (void)createUI{
    // 提前注册
    [self.collectionView registerClass:[RecordSubGrigCell class] forCellWithReuseIdentifier:@"RecordSubGrigCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // 设置约束
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        /*
         UIEdgeInsetsMake(CGFloat top,
         CGFloat left,
         CGFloat bottom,
         CGFloat right)
         */
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}
- (void)loadDataWithArr:(NSArray *)arr{
    self.dataArr = arr;
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 创建cell
    RecordSubGrigCell* cell = (RecordSubGrigCell* )[collectionView dequeueReusableCellWithReuseIdentifier:@"RecordSubGrigCell" forIndexPath:indexPath];
    // 设置数据
    cell.model = self.dataArr[indexPath.item];
    [cell layoutIfNeeded];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (SZRScreenWidth-10*5)/4;
//    SZRLog(@"item高度 hhhh %lf",(width/320*480));
    return CGSizeMake(width, (width/320*480)-40);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    RecordSubGrigCell* cell = (RecordSubGrigCell* )[collectionView cellForItemAtIndexPath:indexPath];
    if (self.imageClickBlock) {
        self.imageClickBlock(indexPath);
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
