//
//  privateHealthVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "privateHealthVC.h"
#import "SZRCollectionView.h"
#import "CollectionViewCell.h"
#import "SZRHUD.h"
#import "XMBadgeView.h"
//顶部scrollView
#import "PrivateHealthScollView.h"
#import "ChatTextVC.h"
#import "DocterListVC.h"
#import "DDMenuController.h"
#import "DoctListModel.h"
#import "LoginModel.h"
#import "GlobalInfo.h"
#import "OverseasMedicalVC.h"
#import "PhysicalExamVC.h"
#import "ExamView.h"
#import "PerfectInformationVC.h"
#define PCH_Label_HEIGHT 30
#define PCH_Label_WIDTH 170
@interface privateHealthVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
/** 头像*/
@property (nonatomic,strong) UIImageView* userIconImageV;
/** 进度条*/
@property (nonatomic,strong) SZRHUD *progress;
/** 网格视图*/
@property(nonatomic,strong)SZRCollectionView * collectionView;
/** 存储collectionView cell中的模型*/
@property(nonatomic,strong)NSArray * dataArr;
/** 定义属性*/
@property (nonatomic,assign)CGFloat collectinViewHeight;
/** 顶部scrollView*/
@property(nonatomic,strong)PrivateHealthScollView * privateHealthScollView;
@property(nonatomic,strong)XMBadgeView * badgeView;

@end

@implementation privateHealthVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // 去掉导航栏阴影线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserInfo) name:kUpdateUserInfoNofiName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSignedDoctorNum) name:@"kUpdatePrivateHealthVCCellSignedDoctor" object:nil];
    //加载数据
    [self loadData];
//    [self.collectionView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

-(void)createUI{
    [self createNavItems:@{NAVLEFTIMAGE:@"directory"}];
    
    //设置背景颜色
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];
    [self topView];
    [self createCollectionView];
    [self updateUserInfo];
}


- (void)topView
{
//    self.privateHealthScollView = [[PrivateHealthScollView alloc] initWithFrame:CGRectMake(0, 64, SZRScreenWidth, kAdaptedHeight(200)) headImage:[DEFAULTS valueForKey:CLIENTHEADPORTRATION] healthValue:0.65 vipLevel:[[VDUserTools VDGetLoginModel].vipLevel intValue]];
    [self.view addSubview:self.privateHealthScollView];

}

- (SZRCollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectinViewHeight = SZRScreenHeight -  CGRectGetMaxY(self.privateHealthScollView.frame) - 49;
        _collectionView = [[SZRCollectionView alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(self.privateHealthScollView.frame), SZRScreenWidth, self.collectinViewHeight) flowLayOut:flow controller:self];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

#pragma mark 创建CollectionView
-(void)createCollectionView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //关闭滑动
    self.collectionView.bounces = NO;
    //提前注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"COLLECTIONVIEWCELL"];
}


#pragma mark 加载数据
- (void)loadData{
    NSDictionary* pararmsDic = @{@"token":[VDUserTools VD_GetToken]};
    [VDNetRequest VD_PostWithURL:VDDoctorCategory_URL arrtribute:@{VDHTTPPARAMETERS:pararmsDic} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject[RESULT] boolValue]) {
                NSMutableArray * itemArray = [[NSMutableArray alloc] init];
//                SZRLog(@"私属健康=%@",kBGDataStr);
                NSDictionary* dataDic = [SZRFunction dictionaryWithJsonString:[RSAAndDESEncrypt DESDecrypt:responseObject[DATA]]];
                NSArray* dataArr = (NSArray* )dataDic;
                for (NSDictionary* dic in dataArr) {
                    CollectionModel* collModel = [[CollectionModel alloc] init];
                    [collModel setValuesForKeysWithDictionary:dic];
                    [itemArray addObject:collModel];
                }
                // 对itemArray排序，根据orderBy字段
                self.dataArr = [itemArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    return [obj1 compare:obj2];
                }];
                // 赋值
                [GlobalInfo getInstance].collectionModel.goodsListArray= self.dataArr;
                // 网络请求之后更新模型，把最新模型缓存起来
                [[GlobalInfo getInstance] persistModel:[GlobalInfo getInstance].collectionModel];
                [self.collectionView reloadData];
            }else{
                VD_ShowBGBackError(NO);
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:self];
                }
            }
        }else{
            //无需网络加载
            self.dataArr = [[NSMutableArray alloc] initWithArray:[GlobalInfo getInstance].collectionModel.goodsListArray];
            [self.collectionView reloadData];
            
            SZRLog(@"error %@",error);
            VD_SHowNetError(NO);
        }
    } noNetwork:^{
        self.dataArr = [[NSMutableArray alloc] initWithArray:[GlobalInfo getInstance].collectionModel.goodsListArray];
        [self.collectionView reloadData];
        VD_SHowNetError(NO);
    }];
    
}
//设置每个cell的大小 Item网格
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SZRScreenWidth/2,kAdaptedHeight(70));
    
}

//定义展示的collectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.dataArr.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0, 0,0);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellID = @"COLLECTIONVIEWCELL";
    CollectionViewCell * collectinCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    collectinCell.layer.borderColor=SZRNavColor.CGColor;
    collectinCell.layer.borderWidth=0.3;
    if (indexPath.item == 0 || indexPath.item == 7) {
        collectinCell.messageImageV.hidden = YES;
    }
    if (self.dataArr.count > 0) {
        [collectinCell loadDataWithModel:self.dataArr[indexPath.item]];
    }
    
    return collectinCell;
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionModel * model = self.dataArr[indexPath.row];
    if ([model.name isEqualToString:@"海外就医"]) {
//        OverseasMedicalVC* overMedVC = [OverseasMedicalVC new];
//        overMedVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:overMedVC animated:YES];
        [MBProgressHUD showTextOnly:@"该功能还未开放！"];
    }else if([model.name isEqualToString:@"健康体检"]) {
        PhysicalExamVC * examVC = [[PhysicalExamVC alloc]init];
        examVC.examState = ExamState_NOCommitExam;
        examVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:examVC animated:YES];
    }else{
        DocterListVC * vc = [[DocterListVC alloc] init];
        vc.doctorTypeId = [NSString stringWithFormat:@"%@",model.doctorTypeId];
        vc.name = model.name;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
   
}

-(void)updateUserInfo{
    self.navigationItem.title = [DEFAULTS valueForKey:CLIENTNAME];
    [self.privateHealthScollView updateHeadImage:[DEFAULTS valueForKey:CLIENTHEADPORTRATION] vipLevel:[[[VDUserTools VDGetLoginModel]vipLevel] intValue]];
}

-(void)updateSignedDoctorNum{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


// 左侧侧滑按钮
- (void)leftBtnClick
{
    AppDelegate * app  = (AppDelegate* )[UIApplication sharedApplication].delegate;
    DDMenuController * ddmenuVC = (DDMenuController *)app.window.rootViewController;
    
    //    NSLog(@"app.window.rootViewController = %@",app.window.rootViewController);
    
    [ddmenuVC showLeftController:YES];
}

-(void)clearUnreadMessage{
    NSArray *conversationList = [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_APPSERVICE),@(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *syncConversations = [[NSMutableArray alloc] init];
        for (int i = 0; i < conversationList.count; i++) {
            RCConversation *conversation = conversationList[i];
            if (conversation.unreadMessageCount > 0) {
                [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:conversation.conversationType targetId:conversation.targetId];
                [syncConversations addObject:conversation];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshConversationList" object:nil];
    });
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
