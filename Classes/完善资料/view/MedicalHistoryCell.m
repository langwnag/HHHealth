//
//  MedicalHistoryCell.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/8/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MedicalHistoryCell.h"
#import "MyCell.h"
//模型
#import "DiseaseHistoryModel.h"

@interface MedicalHistoryCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CellDelegate>

@end
@implementation MedicalHistoryCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.dataArr = [[NSMutableArray alloc]init];
        self.isShowDeleteBtn = NO;
    }
    return self;
}

-(void)createUI{
    //创建病史label
    _leftLabel = [[UILabel alloc]init];
    _leftLabel.textColor = [UIColor lightGrayColor];
    _leftLabel.font = [UIFont systemFontOfSize:16];
    _leftLabel.text = @"自我检测";;
    [self.contentView addSubview:_leftLabel];
    
    //添加
    _addImageV = [[UIImageView alloc]init];
    _addImageV.image = [UIImage imageNamed:@"tianjia"];
    _addImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGest)];
    [self.addImageV addGestureRecognizer:tapGest];
    [self.contentView addSubview:_addImageV];
    
    //提前注册
    [self.collectionView registerClass:[MyCell class] forCellWithReuseIdentifier:@"MyCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    UITapGestureRecognizer * tapCollectionView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDeleteBtn)];
    [self.collectionView addGestureRecognizer:tapCollectionView];
    
    //设置约束
    [self makeConstraints];
    
}

-(void)makeConstraints{
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(5);
        make.left.equalTo(self.contentView).with.offset(15);
        make.height.equalTo(@21);
    }];

    [_addImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).with.offset(-8);
        make.top.equalTo(self.contentView).with.offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@55);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCell * myCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    myCell.indexPath = indexPath;
    myCell.delegate = self;
    myCell.deleteBtn.hidden = self.isShowDeleteBtn ? NO : YES;
    myCell.deseaseLabel.userInteractionEnabled = self.isShowDeleteBtn ? YES : NO;
    myCell.deseaseLabel.text = self.dataArr[indexPath.row];
    [myCell layoutIfNeeded];
    
    return myCell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString * str = self.dataArr[indexPath.row];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 25) options:NSStringDrawingUsesFontLeading attributes:nil context:nil];
    
    return CGSizeMake(rect.size.width+8, 25);
}

-(void)showAllDeleteBtn{
    self.isShowDeleteBtn = YES;
    [self.collectionView reloadData];
}

-(void)hideAllDeleteBtn{
    self.isShowDeleteBtn = NO;
    [self.collectionView reloadData];
   
}

-(void)deleteCellAtIndexpath:(NSIndexPath *)path{
    if (self.dataArr.count == 0) {
        return;
    }

    MyCell * cell = (MyCell *)[self.collectionView cellForItemAtIndexPath:path];
    NSString * deseaseName = cell.deseaseLabel.text;
    [self.collectionView performBatchUpdates:^{
        [self.dataArr removeObjectAtIndex:path.item];
        if (self.deleteArrItemBlock) {
            self.deleteArrItemBlock(deseaseName);
        }
        [self.collectionView deleteItemsAtIndexPaths:@[path]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}
//自己方法
-(void)hideDeleteBtn{
    if (self.isShowDeleteBtn) {
        self.isShowDeleteBtn = NO;
        [self.collectionView reloadData];
    }
}

-(void)loadDiseaseArr:(NSArray *)arr{
    [self.dataArr removeAllObjects];
//    NSLog(@"arr = %@",arr);
    
    for (DiseaseHistoryModel * model in arr) {
        for (NSString * symptom in model.symptomArr) {
            [self.dataArr addObject:symptom];
        }
    }
//    NSLog(@"self.dataArr = %@",self.dataArr);
    [self.collectionView reloadData];
    
}

- (void)tapGest{
    if (self.medicalSkipVCBlock) {
        self.medicalSkipVCBlock();
    }
}

//懒加载
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //collectionView
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
//        layout.estimatedItemSize = CGSizeMake(30, 20);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectNull collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
