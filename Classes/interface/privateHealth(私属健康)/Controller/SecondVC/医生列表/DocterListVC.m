//
//  DocterListVC.m
//  YiJiaYi
//
//  Created by mac on 2016/11/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DocterListVC.h"
#import <RongIMKit/RCConversationModel.h>
#import "DoctListModel.h"
#import "SelecterDoctorCell.h"
#import "DoctorIntroductionVC.h"
#import "ChatTextVC.h"
#import "NoDoctorListView.h"
@interface DocterListVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)SZRTableView * tableView;
@property (nonatomic,strong) NSMutableArray* doctArr;
/** 没有医生列表展示 */
@property (nonatomic,strong) NoDoctorListView* noDoctorListView;

@end

@implementation DocterListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:@{NAVTITLE:self.name,NAVLEFTIMAGE:kBackBtnName}];
    [self createUI];
    [self initData];
    [self createHasSignedReqest];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}



-(void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[SZRTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain controller:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SelecterDoctorCell" bundle:nil] forCellReuseIdentifier:@"SelecterDoctorCell"];
    [SZRFunction SZRSetLayerImage:self.tableView imageStr:@"dl-bj"];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}
#pragma mark 初始化数据源
- (void)initData{
    self.doctArr = [NSMutableArray array];
}


#pragma mark 已签约医师请求
- (void)createHasSignedReqest{
    NSDictionary* paramsDic = @{@"doctorTypeId":self.doctorTypeId};
    [MBProgressHUD showMessage:@"正在加载..."];
    [VDNetRequest VD_PostWithURL:VDHASSIGNEDDoctors_URL arrtribute:@{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:paramsDic token:YES]} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if (![responseObject[RESULT]boolValue]) {
                VD_ShowBGBackError(YES);
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:self];
                }
            }else{
                SZRLog(@"已签约医师 = %@",kBGDataStr);
                NSArray * doctArr = (NSArray *)[SZRFunction dictionaryWithJsonString:[RSAAndDESEncrypt DESDecrypt:responseObject[DATA]]];
                NSMutableArray * signedMarr = [NSMutableArray array];
                [doctArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    DoctListModel* doctModel = [[DoctListModel alloc] init];
                    [doctModel setModelValueWithDic:obj];
                    doctModel.signState = 1;
                    [signedMarr addObject:doctModel];
                }];
                if (doctArr.count == 0) {
                    if (self.doctArr.count == 0) {
                        [self.view addSubview:self.noDoctorListView];
                    }else{
                        [self removeNoDoctorListView];
                    }
                }
              
                [VDUserTools HH_InsertContactDoctor:signedMarr finish:^{
                    
                    [self selectAllDoctor];
                    
                }];
                [MBProgressHUD hideHUD];
            }
        }else{
            SZRLog(@"error %@",error);
            [self selectAllDoctor];
            VD_SHowNetError(YES);
        }
    } noNetwork:^{
        [self selectAllDoctor];
        VD_SHowNetError(YES);
        
    }];

}

-(void)selectAllDoctor{
    [self.doctArr removeAllObjects];
    [self.doctArr addObjectsFromArray:[VDUserTools HH_SelectContactDoctor:self.doctorTypeId]];
    if (self.doctArr.count == 0) {
        [self.view addSubview:self.noDoctorListView];
    }else{
        [self removeNoDoctorListView];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });

}


#pragma mark - 数据源的相关方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.doctArr.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelecterDoctorCell* selectCell = [tableView dequeueReusableCellWithIdentifier:@"SelecterDoctorCell" forIndexPath:indexPath];
    selectCell.hideSelectBtn = YES;
    if (self.doctArr.count > 0) {
        DoctListModel * model = self.doctArr[indexPath.row];
        selectCell.skipDoctorInfoVC = ^(){
            [self skipToDoctorIntroVC:model];
        };
        selectCell.model = model;
    }
    
    return selectCell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctListModel * model = self.doctArr[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SelecterDoctorCell class] contentViewWidth:SZRScreenWidth];
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self chatWithDoctor:self.doctArr[indexPath.row]];
}

-(void)chatWithDoctor:(DoctListModel *)model{
    ChatTextVC * vc = [[ChatTextVC alloc]initWithConversationType:ConversationType_PRIVATE targetId:model.doctorRCId];
    vc.displayUserNameInCell = NO;
    vc.doctorModel = model;
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)skipToDoctorIntroVC:(DoctListModel *)model{
    DoctorIntroductionVC* doctorVC = [[DoctorIntroductionVC alloc] init];
    doctorVC.doctorModel = model;
    [self.navigationController pushViewController:doctorVC animated:YES];
}


- (NoDoctorListView *)noDoctorListView{
    if (!_noDoctorListView) {
        _noDoctorListView = [[NoDoctorListView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight)];
        __weak DocterListVC* weakSelf = self;
        _noDoctorListView.clickVoiceBtnBlock = ^(){
            UIViewController* vc = [[NSClassFromString(@"PhysicianVisitVC") alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _noDoctorListView;
}

- (void)removeNoDoctorListView{
    if (self.noDoctorListView !=nil) {
        [self.noDoctorListView removeFromSuperview];
    }
}

- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
