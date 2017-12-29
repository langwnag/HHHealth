//
//  FunctionView.m
//  YiJiaYi
//
//  Created by mac on 2017/6/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HomeFunctionView.h"
#import "BigItem.h"
#import "SmallCell.h"
#import "DoctListModel.h"
#import "PrivateDoctorModel.h"
#import "CollectionModel.h"
#import "PhysicalExamVC.h"
#import "DocterListVC.h"
#import "HHLoginVC.h"
static NSString *kcellIdentifier = @"collectionCellID";
static NSString *kSmallCellIdentifier = @"SmallCellID";
@interface HomeFunctionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/** collectionView */
@property (nonatomic,strong) UICollectionView* collectionView;
/** collectionView */
@property (nonatomic,strong) UICollectionView* secondCollectionView;

/** 图片 */
@property(nonatomic,copy) NSArray* itmeArr;
/** 类型 */
@property (nonatomic,copy) NSArray* typeArr;
///** 数量 */
//@property(nonatomic,copy) NSArray * signNumArr;
/** 医师数组 */
@property(nonatomic,copy) NSArray * doctorArr;
/** 医师类型数组 */
@property(nonatomic,copy) NSArray * doctorTypeArr;

@property(nonatomic,strong)NSArray * signedDoctorsFromPrivateDoctorModel;



@end
@implementation HomeFunctionView
{
    NSArray * _contentDoctorRCIDArr;
    CollectionModel * _model;
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        [self configUI];
    }
    return self;
}

- (NSArray *)itmeArr{
    if (!_itmeArr) {
        _itmeArr = @[@"healthycheckup",@"dietnutrition",@"psychological consultation"];
        _typeArr = @[@"健康体检",@"食疗营养",@"心理咨询"];
    }
    return _itmeArr;
}
- (NSArray *)doctorArr{
    if (!_doctorArr) {
        _doctorArr = @[@"nurse _practitioner",@"kang _fushi",@"private_doctors",@"overseas_medical"];
    }
    return _doctorArr;
}

- (void)configUI{
    [self.collectionView registerClass:[BigItem class] forCellWithReuseIdentifier:kcellIdentifier];
    [self.secondCollectionView registerClass:[SmallCell class] forCellWithReuseIdentifier:kSmallCellIdentifier];
    [self addSubview:self.collectionView];
    [self addSubview:self.secondCollectionView];
}
#pragma mark collectionViewDelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return self.signsDataArr.count;
    }
    return self.doctorArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (collectionView == self.collectionView) {
        CollectionModel* model = self.signsDataArr[indexPath.item];
        BigItem* bigItem = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
        bigItem.headerImage.image = IMG(self.itmeArr[indexPath.item]);
        bigItem.model = model;
        return bigItem;
    }else{
    
        SmallCell* smallCell = [collectionView dequeueReusableCellWithReuseIdentifier:kSmallCellIdentifier forIndexPath:indexPath];
        smallCell.imageV.image = IMG(self.doctorArr[indexPath.row]);
        switch (indexPath.item) {
            case 0:
                smallCell.model = self.signsDataArr[3];
                break;
            case 1:
                smallCell.model = self.signsDataArr[5];
                break;
            case 2:
                smallCell.model = self.signsDataArr[6];
                break;
            case 3:
                smallCell.model = self.signsDataArr[7];
                break;
            default:
                break;
        }
    return smallCell;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (collectionView == self.collectionView) {
        return CGSizeMake(kAdaptedWidth_2(185), kAdaptedHeight_2(230));
    }
    return CGSizeMake(kAdaptedWidth(65), kAdaptedWidth(65));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    if (collectionView == self.collectionView) {
        return UIEdgeInsetsMake(8,kAdaptedWidth_2(30), 0, kAdaptedWidth_2(30));
    }
    return UIEdgeInsetsMake(kAdaptedHeight_2(19), kAdaptedWidth_2(30), kAdaptedHeight_2(58), kAdaptedWidth_2(30));
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 30;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, kAdaptedHeight_2(235)+8) collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}
- (UICollectionView *)secondCollectionView{
    if (!_secondCollectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        _secondCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame), SZRScreenWidth, kAdaptedHeight_2(174)) collectionViewLayout:layout];
        _secondCollectionView.scrollEnabled = NO;
        _secondCollectionView.delegate = self;
        _secondCollectionView.dataSource = self;
        _secondCollectionView.backgroundColor = [UIColor clearColor];
    }
    return _secondCollectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
        !self.selectItemBlock ? : self.selectItemBlock(indexPath);
    }else{
        !self.selectItemBlockNew ? : self.selectItemBlockNew(indexPath);
    }
}

- (void)setSignsDataArr:(NSArray *)signsDataArr{
    _signsDataArr = signsDataArr;
    [self.collectionView reloadData];
    [self.secondCollectionView reloadData];
}


-(void)mySignedDoctorsFromPrivateDoctorModel{
    NSArray * signedArr = [PrivateDoctorModel findByCriteria:[NSString stringWithFormat:@"where doctorTypeId = %@ and state = 1",_model.doctorTypeId]];
    NSMutableArray * marr = [NSMutableArray array];
    for (PrivateDoctorModel * model in signedArr) {
        [marr addObject:[NSString stringWithFormat:@"%d",model.doctorId]];
    }
    //    SZRLog(@"marr = %@",marr);
    _signedDoctorsFromPrivateDoctorModel = marr;
}


-(void)selectContentDoctor{
    
    NSArray * allContentDoctor = [DoctListModel findByCriteria:[NSString stringWithFormat:@"where doctorTypeId = %@",_model.doctorTypeId]];
    //    SZRLog(@"allContentDoctor = %@ doctorTypeId = %@",allContentDoctor,_model.doctorTypeId);
    NSMutableArray * doctorRCIDArr = [NSMutableArray array];
    if (allContentDoctor.count) {
        //本地缓存有聊过天的医生
        for (DoctListModel * doctorModel in allContentDoctor) {
            [doctorRCIDArr addObject:doctorModel.doctorRCId];
        }
    }else{
        //从登陆成功缓存数据获得签约医生
        for (NSString * signedDoctorID in self.signedDoctorsFromPrivateDoctorModel) {
            [doctorRCIDArr addObject:[SZRFunction doctorRCIDWithID:signedDoctorID]];
        }
    }
    _contentDoctorRCIDArr = doctorRCIDArr;
}

-(void)didReceiveMessageNotification:(NSNotification*)notification{
    
    RCMessage * message = notification.object;
    
    if ([_contentDoctorRCIDArr containsObject:message.senderUserId]) {
        //更新未读消息数
        [self loadUnreadMessageNum];
    }
}

#pragma mark - 更新未读消息数
-(void)loadUnreadMessageNum{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        int totalUnReadCount = 0;
        for (NSString * rcID in _contentDoctorRCIDArr) {
            int count = [[RCIMClient sharedRCIMClient]
                         getUnreadCount:ConversationType_PRIVATE targetId:rcID];
            totalUnReadCount += count;
        }
        //        SZRLog(@"totalUnReadCount = %d",totalUnReadCount);
        SmallCell* cell = (SmallCell* )[self.secondCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.messageImageV.hidden = totalUnReadCount <= 0;
    });
}

@end
