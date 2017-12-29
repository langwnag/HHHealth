//
//  PrivateHealthVC.m
//  YiJiaYi
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PrivateHealthVC.h"

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
/**************新改动************/
#import "HomeFunctionView.h"
#import "HealthShowCell.h"
#import "HealthFoodCell.h"
#import "LYHealthyFoodViewController.h"
#import "LYStoreMainListModel.h"
#import "LYStoreMainViewController.h"
#import "LYGoodsDetailViewController.h"
#import <objc/runtime.h>
#import "SaleGoodsModel.h"


@interface PrivateHealthVC ()<UITableViewDataSource,UITableViewDelegate>
/** 头像*/
@property (nonatomic,strong) UIImageView* userIconImageV;
/** 进度条*/
@property (nonatomic,strong) SZRHUD *progress;
/** 表头 */
@property (nonatomic,strong) UIView* headerView;
/** 顶部scrollView*/
@property(nonatomic,strong)PrivateHealthScollView * privateHealthScollView;
/** 签约医师Item*/
@property (nonatomic,strong) HomeFunctionView* functionV;
/** tableV */
@property (nonatomic,strong) SZRTableView* tableV;
/** 特卖商品数据源 */
@property(nonatomic,copy)NSMutableArray * saleGoodsDataArr;
/** 存储collectionView cell中的模型*/
@property(nonatomic,strong)NSArray * dataArr;
/** 签约医师数据源 */
@property (nonatomic,strong) NSMutableArray* signDataArr;




@end

@implementation PrivateHealthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.saleGoodsDataArr removeAllObjects];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // 去掉导航栏阴影线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserInfo) name:kUpdateUserInfoNofiName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSignedDoctorNum) name:@"kUpdatePrivateHealthVCCellSignedDoctor" object:nil];
    [self loadDataSignHealthDocter];
    [self loadDataSaleGoods];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - 签约医师数据源
- (NSMutableArray *)signDataArr{
    if (!_signDataArr) {
        _signDataArr = [NSMutableArray array];
    }
    return _signDataArr;
}

#pragma mark - 商品特卖数据源
- (NSMutableArray *)saleGoodsDataArr{
    if (!_saleGoodsDataArr) {
        _saleGoodsDataArr = [NSMutableArray array];
    }
    return _saleGoodsDataArr;
}

#pragma mark - 健康师展示请求
- (void)loadDataSignHealthDocter{
    NSDictionary* pararmsDic = @{@"token":[VDUserTools VD_GetToken]};
    [VDNetRequest HH_RequestHandle:pararmsDic
                               URL:VDDoctorCategory_URL
                    viewController:self
                           success:^(id responseObject) {
                               NSArray* doctArr = [CollectionModel mj_objectArrayWithKeyValuesArray:[RSAAndDESEncrypt DESDecrypt:responseObject[DATA]]];
                               // 对doctArr排序，根据orderBy字段
                               self.dataArr = [doctArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                   return [obj1 compare:obj2];
                               }];
                               [self.signDataArr addObjectsFromArray:self.dataArr];
                               
                               self.functionV.signsDataArr = self.signDataArr;
                               [self.tableV reloadData];
                           } failureEndRefresh:^{
                               
                           } showHUD:NO hudStr:@""];
    
}


#pragma mark - 特卖商品网络请求
- (void)loadDataSaleGoods{

    NSDictionary* paramsDic = @{@"commodityTypeId":@"1", @"page":@"1"};
    [VDNetRequest HH_RequestHandle:paramsDic
                               URL:kURL(@"commodity/selectCommodityByTypeId.html")
                    viewController:self
                           success:^(id responseObject) {
                               NSArray* modelArr = [SaleGoodsModel mj_objectArrayWithKeyValuesArray:[RSAAndDESEncrypt DESDecryptResponseObject:responseObject]];
                               [self.saleGoodsDataArr addObjectsFromArray:modelArr];
                               [self.tableV reloadData];
                        
                           } failureEndRefresh:^{
                               
                           } showHUD:NO hudStr:@""];
    

}



#pragma mark - 表头
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, kAdaptedHeight(200)+ kAdaptedHeight_2(417))];
    }
    return _headerView;
}

#pragma mark - 健康指数
- (void)topView
{
    self.privateHealthScollView = [[PrivateHealthScollView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, kAdaptedHeight(200)) headImage:@"" healthValue:0.65 vipLevel:[[VDUserTools VDGetLoginModel].vipLevel intValue] healthStr:@"非常健康" healthValueStr:65 dateStr:@"2017-6-19"];
    [self.headerView addSubview:self.privateHealthScollView];
}

#pragma mark - 展示健康师的视图
- (HomeFunctionView *)functionV{
    if (!_functionV) {
        _functionV = [[HomeFunctionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.privateHealthScollView.frame), SZRScreenWidth, kAdaptedHeight_2(417))];
        __weak PrivateHealthVC* weakSelf = self;
        _functionV.selectItemBlock = ^(NSIndexPath* indexPath){
            CollectionModel* model = weakSelf.signDataArr[indexPath.item];
            if ([model.doctorTypeId integerValue]== 1) {
                PhysicalExamVC * examVC = [[PhysicalExamVC alloc]init];
                examVC.examState = ExamState_NOCommitExam;
                examVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:examVC animated:YES];
            }else{
                if (![[[VDUserTools VDGetLoginModel] vipLevel] isEqual:@0]) {
                    [weakSelf setupSkipDoctorList:model];
                }else{
                    [weakSelf setupActionSheetController];
                }
            }
        };
        _functionV.selectItemBlockNew = ^(NSIndexPath* indexPath){
            CollectionModel* model = weakSelf.signDataArr[indexPath.item];
            switch (indexPath.item) {
                case 0:
                    model = weakSelf.signDataArr[3];
                    break;
                case 1:
                    model = weakSelf.signDataArr[5];
                    break;
                case 2:
                    model = weakSelf.signDataArr[6];
                    break;
                case 3:
                    model = weakSelf.signDataArr[7];
                    break;
                default:
                    break;
            }
            if ([model.doctorTypeId integerValue] == 4) {
                UIViewController* VC = [[NSClassFromString(@"OverseasMedicalVC") alloc] init];
                VC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }else{
                if (![[[VDUserTools VDGetLoginModel] vipLevel] isEqual:@0]) {
                    [weakSelf setupSkipDoctorList:model];
                }else{
                    [weakSelf setupActionSheetController];
                }
            }
        };
    }
    return _functionV;
}

- (void)setupSkipDoctorList:(CollectionModel* )model{
    DocterListVC * vc = [[DocterListVC alloc] init];
    vc.doctorTypeId = [NSString stringWithFormat:@"%@",model.doctorTypeId];
    vc.name = model.name;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark - 展示UI
- (void)configUI{
    
    [self createNavItems:@{NAVLEFTIMAGE:@"directory",NAVRIGHTIMAGE:@"carefamily"}];
    //设置背景颜色
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];
    
    [self.tableV registerNib:[UINib nibWithNibName:@"HealthFoodCell" bundle:nil] forCellReuseIdentifier:@"HealthFoodCell"];
    [self.tableV registerNib:[UINib nibWithNibName:NSStringFromClass([HealthShowCell class]) bundle:nil] forCellReuseIdentifier:@"HealthShowCell"];
    [self.view addSubview:self.tableV];
    self.tableV.tableHeaderView = self.headerView;
    [self topView];
    [self.headerView addSubview:self.functionV];
    [self updateUserInfo];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HealthFoodCell* healthFoodCell = [tableView dequeueReusableCellWithIdentifier:@"HealthFoodCell"];
        return healthFoodCell;
    }else if (indexPath.row == 1){
        HealthShowCell* healthCell = [tableView dequeueReusableCellWithIdentifier:@"HealthShowCell" forIndexPath:indexPath];
        ;
        healthCell.saleGoodsArr = self.saleGoodsDataArr;
        healthCell.clickItemBlock = ^(NSIndexPath* indexPath){
            
            SaleGoodsModel* model = self.saleGoodsDataArr[indexPath.row];
            LYGoodsDetailViewController* vc = [[LYGoodsDetailViewController alloc] init];
            vc.navTitle = model.name;
            vc.commodityId = model.commodityId;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return healthCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == 0 ? 150 : kAdaptedHeight_2(410);
}

- (SZRTableView *)tableV{
    if (!_tableV) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectMake(0, 64, SZRScreenWidth, SZRScreenHeight-64-49) style:UITableViewStylePlain controller:self];
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.backgroundColor = [UIColor clearColor];
    }
    return _tableV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (![[[VDUserTools VDGetLoginModel]vipLevel] isEqual:@0]) {
            LYHealthyFoodViewController* classVC = [[LYHealthyFoodViewController alloc] init];
            classVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:classVC animated:YES];

        }else{
            [self setupActionSheetController];
        }
      
    }else{
        LYStoreMainViewController* storeVC = [[LYStoreMainViewController alloc] init];
        storeVC.hidesBottomBarWhenPushed = YES;
        storeVC.showLeftBtn = YES;
        [self.navigationController pushViewController:storeVC animated:YES];
        }
}

-(void)updateUserInfo{
    self.navigationItem.title = [DEFAULTS valueForKey:CLIENTNAME];
//    [self.privateHealthScollView updateHeadImage:[DEFAULTS valueForKey:CLIENTHEADPORTRATION] vipLevel:[[[VDUserTools VDGetLoginModel]vipLevel] intValue]];
}

-(void)updateSignedDoctorNum{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableV reloadData];
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

- (void)rightBtnClick{
    UIViewController* confirmOrderVC = [NSClassFromString(@"careFamilyVC") new];
    confirmOrderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:confirmOrderVC animated:YES];
}

- (void)setupActionSheetController{
    [SZRFunction createAlertViewTextTitle:@"请先升级为VIP会员，拔打客服咨询" withTextMessage:nil WithButtonMessages:@[@"取消",@"确定"] Action:^(NSInteger indexPath) {
        if (indexPath == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://010-89029276"]];
        }
    } viewVC:self style:UIAlertControllerStyleAlert];
}



@end
